class CreateStorytimeApiTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :storytime_api_tokens do |t|
      t.integer :site_id
      t.integer :user_id
      t.string :name, null: false
      t.string :token_digest, null: false
      t.string :token_prefix
      t.datetime :last_used_at
      t.datetime :expires_at

      t.timestamps
    end

    add_index :storytime_api_tokens, :token_digest, unique: true
    add_index :storytime_api_tokens, :site_id
  end
end
