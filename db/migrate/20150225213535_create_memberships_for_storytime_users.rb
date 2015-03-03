class CreateMembershipsForStorytimeUsers < ActiveRecord::Migration
  def change
    add_column :storytime_sites, :user_id, :integer
    add_index :storytime_sites, :user_id

    Storytime::Migrators::V1.create_user_memberships
  end
end
