# This migration comes from storytime (originally 20140521190606)
class CreateStorytimeRoles < ActiveRecord::Migration
  def change
    create_table :storytime_roles do |t|
      t.string :name, index: true

      t.timestamps
    end
  end
end
