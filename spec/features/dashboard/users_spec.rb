require 'spec_helper'

describe "In the dashboard, Users" do
  context "as Admin" do
    before{ login_admin }

    it "lists users", js: true do
      FactoryGirl.create_list(:user, 3)
      visit storytime.dashboard_path
      click_link "users-link"
      
      Storytime.user_class.all.each do |u|
        expect(page).to have_content u.storytime_name
      end
    end

    it "edits a user", js: true do
      u = FactoryGirl.create :user
      visit storytime.dashboard_path
      click_link "profile-link"
      fill_in "user_email", with: "new_email@example.com"
      click_button "Update"
      wait_for_ajax
      expect(current_user.reload.email).to eq "new_email@example.com"
    end

    it "creates a user", js: true do
      visit storytime.dashboard_path
      click_link "users-link"
      click_link "new-user-link"
      fill_in "user_email", with: "new_user@example.com"
      fill_in "user_password", with: "password"
      fill_in "user_password_confirmation", with: "password"
      click_button "Create"
      wait_for_ajax
      expect(Storytime.user_class.last.email).to eq "new_user@example.com"
    end

    it "deletes a user", js: true do
      user = FactoryGirl.create(:user)
      visit storytime.dashboard_path
      click_link "users-link"

      expect {
        find("#user_#{user.id}").hover
        click_link("delete_user_#{user.id}")
        wait_for_ajax
      }.to change(Storytime.user_class, :count).by(-1)
    end
  end
end