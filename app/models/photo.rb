class Photo < ApplicationRecord
  enum :photo_sharing, { public: 0, private: 1 }, prefix: true unless defined_enums.key?("photo_sharing")
  # config for carrierwave upload file
  mount_uploader :image, ImageUploader

  belongs_to :user

  has_many :album_photos
  has_many :albums, through: :album_photos

  # validations
  validates :title, presence: true
  validates :image, presence: true
  validates :photo_sharing, presence: true
  validates :description, length: { maximum: 500 }, presence: true

  # scopes
  # get public photos from users followed by current user
  scope :public_photos, -> { where(photo_sharing: :public) }

  scope :public_photos_from_following, ->(current_user) { where(photo_sharing: :public).where(user_id: current_user.following.select(:id))
}
end
