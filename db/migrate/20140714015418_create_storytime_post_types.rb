class CreateStorytimePostTypes < ActiveRecord::Migration
  def change
    create_table :storytime_post_types do |t|
      t.string :name, index: true
      t.boolean :permanent, default: false

      t.timestamps
    end
  end
end
