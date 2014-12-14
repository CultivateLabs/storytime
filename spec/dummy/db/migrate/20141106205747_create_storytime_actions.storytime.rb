# This migration comes from storytime (originally 20140521191744)
class CreateStorytimeActions < ActiveRecord::Migration
  def change
    create_table :storytime_actions do |t|
      t.string :name
      t.string :guid, index: true

      t.timestamps
    end
  end
end
