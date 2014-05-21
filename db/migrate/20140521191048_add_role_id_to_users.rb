class AddRoleIdToUsers < ActiveRecord::Migration
  def change
    add_column :storytime_users, :role_id, :integer
    add_index :storytime_users, :role_id
  end
end
