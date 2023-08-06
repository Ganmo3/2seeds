class AddUniqueIndexToUsersAccount < ActiveRecord::Migration[6.1]
  def change
    add_index :users, :account, unique: true
  end
end
