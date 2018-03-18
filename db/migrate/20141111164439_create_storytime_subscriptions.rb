class CreateStorytimeSubscriptions < ActiveRecord::Migration[4.2]
  def change
    create_table :storytime_subscriptions do |t|
      t.string :email
      t.boolean :subscribed, default: true
      t.string :token, index: true

      t.timestamps
    end

    Storytime::Action.seed
    Storytime::Permission.seed
  end
end
