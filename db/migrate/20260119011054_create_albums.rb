class CreateAlbums < ActiveRecord::Migration[8.1]
  def change
    create_table :albums do |t|
      t.string :title
      t.text :description
      t.integer :sharing, default: 0, null: false
      t.timestamps
    end
  end
end
