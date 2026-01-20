class User < ApplicationRecord
  enum :role, { user: 0, admin: 1 }, prefix: true
  # Associations for follows
  has_many :active_follows, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_follows, source: :followed

  has_many :passive_follows, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_follows, source: :follower

  # Association for photos
  has_many :photos
end
