class CreateStorytimeTaggings < ActiveRecord::Migration[4.2]
  def change
    create_table :storytime_taggings do |t|
      t.belongs_to :tag, index: true
      t.belongs_to :post, index: true

      t.timestamps
    end
  end
end
