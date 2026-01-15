class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :firtsName
      t.string :lastName
      t.string :email
      t.string :password
      
      t.timestamps
    end
  end
end
