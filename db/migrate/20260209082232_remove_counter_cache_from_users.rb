class RemoveCounterCacheFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :photos_count, :integer
    remove_column :users, :albums_count, :integer
    remove_column :users, :following_count, :integer
    remove_column :users, :followers_count, :integer
  end
end
