# This migration comes from storytime (originally 20140916183056)
class CreateStorytimeAutosaves < ActiveRecord::Migration
  def change
    create_table :storytime_autosaves do |t|
      t.text :content
      t.references :autosavable, polymorphic: true

      t.timestamps
    end

    add_index :storytime_autosaves, [:autosavable_type, :autosavable_id], name: "autosavable_index"
  end
end