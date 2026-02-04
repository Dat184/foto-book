class RemoveCurrentSignInAtFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :current_sign_in_at, :datetime
  end
end
