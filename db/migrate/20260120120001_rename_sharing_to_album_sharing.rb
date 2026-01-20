class RenameSharingToAlbumSharing < ActiveRecord::Migration[8.1]
  def change
    rename_column :albums, :sharing, :album_sharing
  end
end
