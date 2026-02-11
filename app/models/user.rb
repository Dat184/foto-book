class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :omniauthable, omniauth_providers: [ :google_oauth2, :facebook, :twitter ]
  enum :role, { user: 0, admin: 1 }, prefix: true
  enum :status, { active: 0, inactive: 1 }, prefix: true

  mount_uploader :avatar, AvatarUploader

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  # Override Devise method to prevent inactive users from signing in
  def active_for_authentication?
    super && status_active?
  end

  def self.from_omniauth(auth)
    user = User.find_by(provider: auth.provider, uid: auth.uid)
    return user if user

    email = auth.info.email
    user = User.find_or_initialize_by(email: email)
    user.provider = auth.provider
    user.uid      = auth.uid
    user.firstName = auth.info.first_name || "User" if user.firstName.blank?
    user.lastName  = auth.info.last_name  || "Name"  if user.lastName.blank?
    user.password = Devise.friendly_token[0, 20] if user.new_record?

    # Skip email confirmation for OAuth users since the provider already verified the email
    user.skip_confirmation! if user.respond_to?(:skip_confirmation!)

    user.save!
    user
  end

  # Custom message for inactive users
  def inactive_message
    status_inactive? ? :inactive_account : super
  end

  # Associations for follows
  has_many :active_follows, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_follows, source: :followed

  has_many :passive_follows, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_follows, source: :follower

  # Association for photos
  has_many :photos
  # Association for albums
  has_many :albums

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :firstName, presence: true
  validates :lastName, presence: true
  scope :role_user, -> { where(role: :user) }
end
