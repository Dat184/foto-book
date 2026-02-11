class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable
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
  validates :password, presence: true,
                       length: { minimum: 6 }
  scope :role_user, -> { where(role: :user) }
end
