# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

Tạo 1 bảng follows làm bảng trung gian
class CreateRelationships < ActiveRecord::Migration[7.0]
def change
create_table :relationships do |t| # follower_id: ID của người đi follow
t.integer :follower_id # followed_id: ID của người được follow
t.integer :followed_id

      t.timestamps
    end

    # Đánh index để tìm kiếm nhanh
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    # Đảm bảo 1 người không thể follow người kia 2 lần
    add_index :relationships, [:follower_id, :followed_id], unique: true

end
end

# app/models/relationship.rb

class Relationship < ApplicationRecord
belongs_to :follower, class_name: "User"
belongs_to :followed, class_name: "User"

# Validates (Optional nhưng nên có)

validates :follower_id, presence: true
validates :followed_id, presence: true
end

Cấu hình trong model user

# app/models/user.rb

class User < ApplicationRecord

# 1. CHIỀU ĐI FOLLOW (Active Relationships)
# Định nghĩa mối quan hệ: Những người mà tôi đang follow
# "active_relationships" là tên tự đặt, foreign_key là "follower_id" (tôi là người đi follow)
has_many :active_relationships, class_name: "Relationship",
foreign_key: "follower_id",
dependent: :destroy

# Bắc cầu qua active_relationships để lấy danh sách người dùng (following)
# source: :followed nghĩa là lấy cột "followed_id" trong bảng relationship
has_many :following, through: :active_relationships, source: :followed
# 2. CHIỀU ĐƯỢC FOLLOW (Passive Relationships)
# Định nghĩa mối quan hệ: Những người đang follow tôi
# foreign_key là "followed_id" (tôi là người bị follow)

has_many :passive_relationships, class_name: "Relationship",
foreign_key: "followed_id",
dependent: :destroy

# Bắc cầu qua passive_relationships để lấy danh sách người theo dõi (followers)

# source: :follower nghĩa là lấy cột "follower_id"

has_many :followers, through: :passive_relationships, source: :follower

# --- CÁC HELPER METHODS (Nên viết thêm để dễ dùng) ---

# Follow một user

def follow(other_user)
following << other_user unless self == other_user
end

# Unfollow một user

def unfollow(other_user)
following.delete(other_user)
end

# Kiểm tra xem có đang follow user đó không?

def following?(other_user)
following.include?(other_user)
end
end
