class CreateStorytimePages < ActiveRecord::Migration
  def change
    create_table :storytime_pages do |t|
      t.belongs_to :user, index: true
      t.string :title
      t.string :slug
      t.text :content
      t.boolean :published

      t.timestamps
    end
  end
end
