require 'spec_helper'

describe "In the dashboard, Sites" do

  it "creates a site" do
    login FactoryGirl.create(:user), true
    expect(Storytime::Site.count).to eq(0)
    
    visit new_dashboard_site_path

    fill_in "site_title", with: "The Site"
    fill_in "site_custom_domain", with: "example.lvh.me"
    fill_in "site_subscription_email_from", with: "test@example.com"
    
    click_button "Save"

    # since creating a site redirects you to a new domain, you are not logged in
    fill_in "user_email", with: current_user.email
    fill_in "user_password", with: current_user.password
    click_on "Log in"
    
    expect(page).to have_content("Pages")
    expect(Storytime::Site.count).to eq(1)

    site = Storytime::Site.last
    expect(site.title).to eq("The Site")
    expect(site.custom_domain).to eq("example.lvh.me")
    expect(site.subscription_email_from).to eq("test@example.com")
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
      
      expect(page).to have_content("Your changes were saved successfully")
      site.reload
      expect(site.title).to eq "The Site's New Name"
    end
  end
end
