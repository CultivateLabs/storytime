class RemoveStorytimeRoleIdFromUsers < ActiveRecord::Migration
  def change
    remove_column Storytime.user_class.table_name.to_sym, :storytime_role_id
  end
end
