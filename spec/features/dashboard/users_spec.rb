require 'spec_helper'

describe "In the dashboard, Users" do
  context "as Admin" do
    before{ login_admin }

    it "edits own profile", js: true do
      u = User.last
      visit storytime.dashboard_path
      click_link "utility-menu-toggle"
      click_link "profile-link"
      fill_in "user_email", with: "new_email@example.com"
      click_button "Save"

      within "#storytime-modal" do
        storytime_name_field = find_field('user_storytime_name').value
        storytime_email_field = find_field('user_email').value

        expect(storytime_name_field).to eq u.storytime_name
        expect(storytime_email_field).to eq "new_email@example.com"
      end
    end

    it "edits another user's profile", js: true do
      FactoryGirl.create :membership, site: @current_site 
      u = User.last

      visit storytime.dashboard_path
      click_link "utility-menu-toggle"
      click_link "users-link"

      click_link u.storytime_name

      fill_in "user_email", with: "change_email@example.com"
      click_button "Save"

      within "#storytime-modal" do
        storytime_name_field = find_field('user_storytime_name').value
        storytime_email_field = find_field('user_email').value

        expect(storytime_name_field).to eq u.storytime_name
        expect(storytime_email_field).to eq "change_email@example.com"
      end
    end

    it "creates a user", js: true do
      visit storytime.dashboard_path
      click_link "utility-menu-toggle"
      click_link "users-link"
      
      click_link "new-user-link"

      fill_in "user_storytime_name", with: "New Storytime Username"
      fill_in "user_email", with: "new_user@example.com"
      select "Editor", from: "Storytime role"
      fill_in "user_password", with: "password"
      fill_in "user_password_confirmation", with: "password"
      click_button "Save"
      
      within "#storytime-modal" do
        expect(page).to have_content "New Storytime Username"
      end
    end

  end
end