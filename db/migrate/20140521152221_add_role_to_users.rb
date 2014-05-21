class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :storytime_users, :role, :integer, default: 0
  end
end
