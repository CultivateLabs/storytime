class CreateStorytimeCategories < ActiveRecord::Migration
  def change
    create_table :storytime_categories do |t|
      t.string :name, index: true
      t.boolean :excluded_from_primary_feed, default: false 

      t.timestamps
    end
  end
end
