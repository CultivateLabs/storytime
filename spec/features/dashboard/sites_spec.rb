require 'spec_helper'

describe "In the dashboard, Sites" do

  it "creates a site" do
    login FactoryGirl.create(:admin), true
    Storytime::Site.count.should == 0

    visit new_dashboard_site_path
    fill_in "site_title", with: "The Site"
    click_button "Save"
    
    page.should have_content(I18n.t('flash.sites.create.success'))
    Storytime::Site.count.should == 1

    page = Storytime::Site.last
    page.title.should == "The Site"
  end

  context "as a logged in user" do
    before{ login_admin }

    it "updates a site", js: true do
      site = Storytime::Site.last

      visit storytime.dashboard_path
      click_link "utility-menu-toggle"
      click_link "site-settings-link"
      fill_in "site_title", with: "The Site's New Name"
      click_button "Save"
      
      find '#storytime-modal' 
      site.reload
      expect(site.title).to eq "The Site's New Name"
    end
  end
end
