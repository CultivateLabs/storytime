class SeedPermissions < ActiveRecord::Migration[4.2]
  def up
    Storytime::Permission.reset_column_information
    Storytime::Permission.seed
  end
  
  def down
  end
end
