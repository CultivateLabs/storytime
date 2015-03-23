class SeedPermissions < ActiveRecord::Migration
  def up
    Storytime::Permission.seed
  end
  
  def down
  end
end
