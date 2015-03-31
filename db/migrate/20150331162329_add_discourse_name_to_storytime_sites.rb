class AddDiscourseNameToStorytimeSites < ActiveRecord::Migration
  def change
    add_column :storytime_sites, :discourse_name, :string
  end
end
