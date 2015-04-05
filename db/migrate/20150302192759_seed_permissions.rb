class SeedPermissions < ActiveRecord::Migration
  def up
    Storytime::Permission.reset_column_information
    Storytime::Permission.seed
  end
  
  def down
  end
end
