class AddDiscourseNameToStorytimeSites < ActiveRecord::Migration[4.2]
  def change
    add_column :storytime_sites, :discourse_name, :string
  end
end
