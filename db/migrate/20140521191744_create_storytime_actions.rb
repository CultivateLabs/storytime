class CreateStorytimeActions < ActiveRecord::Migration[4.2]
  def change
    create_table :storytime_actions do |t|
      t.string :name
      t.string :guid, index: true

      t.timestamps
    end
  end
end
