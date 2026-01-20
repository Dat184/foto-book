class RenameSharingToPhotoSharingInPhotos < ActiveRecord::Migration[8.1]
  def change
    rename_column :photos, :sharing, :photo_sharing
  end
end
