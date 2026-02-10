class Album < ApplicationRecord
  # Cú pháp: enum :tên_cột, { hash_giá_trị }, option
  # Lưu ý: dùng "prefix: true" thay vì "_prefix: true" (dù cả 2 đều chạy, nhưng prefix chuẩn hơn ở cú pháp mới)
  enum :album_sharing, { public: 0, private: 1 }, prefix: true

  belongs_to :user

  has_many :album_photos
  has_many :photos, through: :album_photos

  validates :title, presence: true, length: { maximum: 140 }
  validates :album_sharing, presence: true
  validates :description, length: { maximum: 300 }, presence: true
  validates :photos, presence: true

  scope :public_albums, -> { where(album_sharing: :public) }
  scope :public_albums_from_following, ->(current_user) { where(album_sharing: :public).where(user_id: current_user.following.select(:id)) }
end
