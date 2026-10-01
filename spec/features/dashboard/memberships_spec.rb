require 'spec_helper'

describe "In the dashboard, Users", type: :feature do
  context "as Admin" do
    before{ login_admin }

    it "provides links to all the sites where the user has a membership", js: true do
      other_site = FactoryBot.create(:site)
      FactoryBot.create(:membership, user: @current_user, site: other_site)

      visit storytime.dashboard_path

      click_link @current_site.title

      expect(page).to have_link(@current_site.title, href: "")
      expect(page).to have_link(other_site.title, href: storytime.dashboard_url(host: other_site.custom_domain, port: Capybara.current_session.server.port))
    end

    it "lists users for a site", js: true do
      FactoryBot.create_list(:user, 3)

      Storytime.user_class.all.each do |user|
        user.storytime_memberships.create(site: @current_site, storytime_role: Storytime::Role.find_by(name: "writer"))
      end

      visit storytime.dashboard_path
      click_link "utility-menu-toggle"
      click_link "users-link"

      Storytime.user_class.all.each do |u|
        expect(page).to have_content u.storytime_name
      end
    end

    it "deletes a user from the site", js: true do
      user = FactoryBot.create(:user)
      membership = user.storytime_memberships.create(site: @current_site, storytime_role: Storytime::Role.find_by(name: "writer"))

      user_count = Storytime.user_class.count
      membership_count = Storytime::Membership.count

      visit storytime.dashboard_path
      click_link "utility-menu-toggle"
      click_link "users-link"

      expect(page).to have_content(user.storytime_name)

      find("#membership_#{membership.id}").hover
      click_link("delete_membership_#{membership.id}")

      expect(page).to_not have_content(user.storytime_name)

      expect(Storytime.user_class.count).to eq(user_count)
      expect(Storytime::Membership.count).to eq(membership_count-1)
    end


    it "edits a user's local role without exposing global identity fields", js: true do
      membership = FactoryBot.create(:membership, site: @current_site)
      user = membership.user
      original_email = user.email

      visit storytime.dashboard_path
      click_link "utility-menu-toggle"
      click_link "users-link"
      click_link user.storytime_name

      expect(page).not_to have_field("membership_user_attributes_email")
      expect(page).not_to have_content("Add an Existing User")
      select "Editor", from: "Storytime role"
      click_button "Save"

      expect(page).to have_content("Your changes were saved successfully")
      expect(membership.reload.storytime_role.name).to eq("editor")
      expect(user.reload.email).to eq(original_email)
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
