# This migration comes from storytime (originally 20140516141252)
class CreateStorytimeVersions < ActiveRecord::Migration
  def change
    create_table :storytime_versions do |t|
      t.text :content
      t.references :user, index: true
      t.references :versionable, polymorphic: true

      t.timestamps
    end
    add_index :storytime_versions, [:versionable_type, :versionable_id], name: "versionable_index"
  end
end
