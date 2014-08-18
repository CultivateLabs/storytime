class CreateStorytimeCustomFields < ActiveRecord::Migration
  def change
    create_table :storytime_custom_fields do |t|
      t.string :name
      t.belongs_to :post_type, index: true
      t.string :type
      t.boolean :required
      t.string :options_scope

      t.timestamps
    end
  end
end
