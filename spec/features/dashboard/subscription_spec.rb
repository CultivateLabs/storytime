require 'spec_helper'

describe "In the dashboard, Subscriptions" do
  before do
    login_admin
  end

  it "lists subscriptions", js: true do
    3.times{ FactoryGirl.create(:subscription, site: @current_site) }
    visit storytime.dashboard_path
    click_link "utility-menu-toggle"
    click_link "subscriptions-link"
    # wait_for_ajax

    Storytime::Subscription.all.each do |s|
      expect(page).to have_content s.email
    end
  end

  it "creates a subscription", js: true do
    visit storytime.dashboard_path
    click_link "utility-menu-toggle"
    click_link "subscriptions-link"
    # wait_for_ajax
    click_link "new-subscription-link"
    # wait_for_ajax

    fill_in "subscription_email", with: "some_random_email@example.com"
    click_button "Save"
      
    within "#storytime-modal" do
      expect(page).to have_content "some_random_email@example.com"
    end
  end

  it "updates a subscription", js: true do
    subscription = FactoryGirl.create(:subscription, site: @current_site)

    expect(Storytime::Subscription.count).to eq(1)
    expect(subscription.subscribed?).to eq(true)

    visit storytime.dashboard_path
    click_link "utility-menu-toggle"
    click_link "subscriptions-link"
    
    within "#storytime-modal" do
      click_link "edit-subscription-#{subscription.id}"
    end

    within "#storytime-modal" do
      fill_in "subscription_email", with: "johndoe@example.com"
      uncheck "subscription_subscribed"
      click_button "Save"
    end

    within "#storytime-modal" do 
      expect(page).to have_content "johndoe@example.com"
    end
  end
end