class CreateStorytimeArtifacts < ActiveRecord::Migration[7.0]
  def change
    create_table :storytime_artifacts do |t|
      t.integer :site_id
      t.integer :user_id
      t.string :name, null: false
      t.string :token, null: false
      t.text :content
      t.string :content_type, default: "text/html"
      t.bigint :byte_size
      t.string :original_filename
      t.string :password_digest
      t.datetime :expires_at

      t.timestamps
    end

    add_index :storytime_artifacts, :token, unique: true
    add_index :storytime_artifacts, :site_id
    add_index :storytime_artifacts, :expires_at
  end
end
