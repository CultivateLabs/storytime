class CreateWidgets < ActiveRecord::Migration[4.2]
  def change
    create_table :widgets do |t|
      t.string :name

      t.timestamps
    end
  end
end
