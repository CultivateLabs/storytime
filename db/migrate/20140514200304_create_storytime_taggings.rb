class CreateStorytimeTaggings < ActiveRecord::Migration
  def change
    create_table :storytime_taggings do |t|
      t.belongs_to :tag, index: true
      t.belongs_to :post, index: true

      t.timestamps
    end
  end
end
