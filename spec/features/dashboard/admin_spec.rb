require "spec_helper"

describe "In the dashboard, Admin" do
  before do 
    login_admin
  end

  it "lists widgets" do
    3.times{ FactoryGirl.create(:widget) }
    visit storytime.dashboard_admin_index_path(resource_name: "widgets")
    
    Widget.all.each do |widget|
      expect(page).to have_content widget.name
    end
  end

end