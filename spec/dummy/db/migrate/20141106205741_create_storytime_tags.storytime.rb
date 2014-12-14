# This migration comes from storytime (originally 20140514200234)
class CreateStorytimeTags < ActiveRecord::Migration
  def change
    create_table :storytime_tags do |t|
      t.string :name

      t.timestamps
    end
  end
end
