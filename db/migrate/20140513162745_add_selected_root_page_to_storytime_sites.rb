class AddSelectedRootPageToStorytimeSites < ActiveRecord::Migration
  def change
    add_reference :storytime_sites, :selected_root_page, index: true
  end
end
