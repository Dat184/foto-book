class Photo < ApplicationRecord
  enum :photo_sharing, { public: 0, private: 1 }, prefix: true

  belongs_to :user

  has_many :album_photos
  has_many :albums, through: :album_photos
end
