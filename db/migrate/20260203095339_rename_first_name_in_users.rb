class RenameFirstNameInUsers < ActiveRecord::Migration[8.1]
  def change
    rename_column :users, :firtsName, :firstName
  end
end
