# This migration comes from storytime (originally 20140521191048)
class AddStorytimeRoleIdToUsers < ActiveRecord::Migration
  def change
    add_column Storytime.user_class.table_name.to_sym, :storytime_role_id, :integer
    add_index Storytime.user_class.table_name.to_sym, :storytime_role_id
  end
end
