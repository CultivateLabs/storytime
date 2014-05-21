class CreateStorytimeRoles < ActiveRecord::Migration
  def change
    create_table :storytime_roles do |t|
      t.string :name

      t.timestamps
    end
  end
end
