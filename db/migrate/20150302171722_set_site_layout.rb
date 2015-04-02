class SetSiteLayout < ActiveRecord::Migration
  def up
    Storytime::Migrators::V1.set_site_layout
  end

  def down
  end
end
