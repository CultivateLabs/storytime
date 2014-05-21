require 'spec_helper'

describe "In the dashboard, Users" do
  context "as Admin" do
    before{ login_admin }

    it "lists users" do
      FactoryGirl.create_list(:user, 3)
      visit dashboard_users_path
      
      Storytime::User.all.each do |u|
        page.should have_content u.email
      end
    end

    it "edits a user" do
      u = FactoryGirl.create :user
      visit edit_dashboard_user_path(u)
      fill_in "user_email", with: "new_email@example.com"
      click_button "Update"
      page.should have_content "new_email@example.com"
    end

    it "creates a user" do
      visit new_dashboard_user_path
      fill_in "user_email", with: "new_user@example.com"
      fill_in "user_password", with: "password"
      fill_in "user_password_confirmation", with: "password"
      click_button "Create"
      page.should have_content I18n.t("flash.users.create.success")
      page.should have_content "new_user@example.com"
    end

    it "deletes a user", js: true do
      FactoryGirl.create_list(:user, 3)
      visit dashboard_users_path
      p1 = Storytime::User.first
      p2 = Storytime::User.last
      click_link("delete_user_#{p2.id}")

      page.should_not have_content(p2.email)
      page.should have_content(p1.email)

      expect{ p2.reload }.to raise_error
    end
  end
end