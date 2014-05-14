require 'spec_helper'

describe "In the dashboard, Sites" do

  it "creates a site" do
    login FactoryGirl.create(:user), true
    Storytime::Site.count.should == 0

    visit new_dashboard_site_path
    fill_in "site_title", with: "The Site"
    click_button "Create Site"
    
    page.should have_content(I18n.t('flash.sites.create.success'))
    Storytime::Site.count.should == 1

    page = Storytime::Site.last
    page.title.should == "The Site"
  end

  context "as a logged in user" do
    before{ login }

    it "updates a site" do
      Storytime::Site.count.should == 1

      visit edit_dashboard_site_path(current_site)
      fill_in "site_title", with: "The Site's New Name"
      click_button "Update Site"
      
      page.should have_content(I18n.t('flash.sites.update.success'))
      Storytime::Site.count.should == 1

      s = Storytime::Site.last
      s.title.should == "The Site's New Name"
    end

    it "new redirects to edit if a site already exists" do
      visit new_dashboard_site_path
      page.should have_content("Editing site")
    end
  end
end
