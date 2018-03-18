class SeedNewActionsAndPermissions < ActiveRecord::Migration[4.2]
  def up
    Storytime::Action.seed
    Storytime::Permission.seed
  end

  def down
  end
end
