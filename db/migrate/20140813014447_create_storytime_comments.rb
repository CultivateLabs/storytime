class CreateStorytimeComments < ActiveRecord::Migration
  def change
    create_table :storytime_comments do |t|
      t.text :content
      t.references :user, index: true
      t.references :post, index: true

      t.timestamps
    end
  end
end
