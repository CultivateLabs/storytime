class CreateMembershipsForStorytimeUsers < ActiveRecord::Migration
  def change
    Storytime::Migrators::V1.create_user_memberships
    remove_column Storytime.user_class.table_name.to_sym, :storytime_role_id
  end
end
