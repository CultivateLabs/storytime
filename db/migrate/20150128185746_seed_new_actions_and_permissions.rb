class SeedNewActionsAndPermissions < ActiveRecord::Migration
  def up
    Storytime::Action.seed
    Storytime::Permission.seed
  end

  def down
  end
end
