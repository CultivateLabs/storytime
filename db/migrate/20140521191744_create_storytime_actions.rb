class CreateStorytimeActions < ActiveRecord::Migration
  def change
    create_table :storytime_actions do |t|
      t.string :name

      t.timestamps
    end
  end
end
