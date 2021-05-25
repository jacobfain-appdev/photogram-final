class AddPrivateToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :private, :boolean
    remove_column :users, :status
  end
end
