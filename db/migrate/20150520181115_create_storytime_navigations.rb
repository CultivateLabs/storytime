class CreateStorytimeNavigations < ActiveRecord::Migration
  def change
    create_table :storytime_navigations do |t|
      t.string :name
      t.string :handle
      t.integer :site_id

      t.timestamps null: false
    end
    add_index :storytime_navigations, :site_id
  end
end
