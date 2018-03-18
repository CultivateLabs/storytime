class CreateStorytimePermissions < ActiveRecord::Migration[4.2]
  def change
    create_table :storytime_permissions do |t|
      t.belongs_to :role, index: true
      t.belongs_to :action, index: true

      t.timestamps
    end
  end
end
