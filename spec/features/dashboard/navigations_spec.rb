require 'spec_helper'

describe "In the dashboard, Navigations" do

  before{ login_admin }
  
  it "renders the navigations index" do
    visit dashboard_navigations_path
    expect(page).to have_content I18n.t('storytime.dashboard.navigations.index.header')
  end

  it "creates a new navigation list" do 
    visit new_dashboard_navigation_path

    expect{
      fill_in "navigation_name", with: "Main Navigation"
      fill_in "navigation_handle", with: "main"
      find("input[name='commit']").click()
    }.to change(Storytime::Navigation, :count).by(1)
  end

  it "updates a navigation list" do
    Storytime::Site.current_id = current_site.id
    nav = FactoryGirl.create(:navigation, site_id: current_site.id)
    visit edit_dashboard_navigation_path(nav)

    fill_in "navigation_name", with: "New Name"
    find("input[name='commit']").click()
    
    nav.reload
    expect(nav.name).to eq "New Name"
  end
end
