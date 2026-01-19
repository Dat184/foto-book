class AddSharingToPhotos < ActiveRecord::Migration[8.1]
  def change
    add_column :photos, :sharing, :integer, default: 0, null: false
  end
end
