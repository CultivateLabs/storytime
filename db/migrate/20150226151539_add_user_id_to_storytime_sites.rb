class AddUserIdToStorytimeSites < ActiveRecord::Migration
  def change
    add_column :storytime_sites, :user_id, :integer
    add_index :storytime_sites, :user_id
  end
end
