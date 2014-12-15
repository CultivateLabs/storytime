# This migration comes from storytime (originally 20140521191728)
class CreateStorytimePermissions < ActiveRecord::Migration
  def change
    create_table :storytime_permissions do |t|
      t.belongs_to :role, index: true
      t.belongs_to :action, index: true

      t.timestamps
    end
  end
end
