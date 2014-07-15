class CreateStorytimePostTypes < ActiveRecord::Migration
  def change
    create_table :storytime_post_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
