require 'spec_helper'

describe "In the dashboard, Users" do
  context "as Admin" do
    before{ login_admin }

    it "edits a user", js: true do
      u = FactoryGirl.create :user
      visit storytime.dashboard_path
      click_link "utility-menu-toggle"
      click_link "profile-link"
      fill_in "user_email", with: "new_email@example.com"
      click_button "Save"

      within "#storytime-modal" do
        expect(page).to have_content u.storytime_name
        expect(u.reload.email).to eq "new_email@example.com"
      end
    end

    it "creates a user", js: true do
      visit storytime.dashboard_path
      click_link "utility-menu-toggle"
      click_link "users-link"
      
      click_link "new-user-link"

      fill_in "user_email", with: "new_user@example.com"
      fill_in "user_password", with: "password"
      fill_in "user_password_confirmation", with: "password"
      click_button "Save"
      
      within "#storytime-modal" do
        expect(page).to have_content "new_user@example.com"
      end
    end

  end
end