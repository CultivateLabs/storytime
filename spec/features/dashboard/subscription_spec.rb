require 'spec_helper'

describe "In the dashboard, Subscriptions" do
  before do
    login_admin
  end

  it "lists subscriptions", js: true do
    3.times{ FactoryGirl.create(:subscription) }
    visit storytime.dashboard_path
    click_link "subscriptions-link"
    wait_for_ajax

    Storytime::Subscription.all.each do |s|
      expect(page).to have_content s.email
    end
  end

  it "creates a subscription", js: true do
    visit storytime.dashboard_path
    click_link "subscriptions-link"
    wait_for_ajax
    click_link "new-subscription-link"
    wait_for_ajax

    expect{
      fill_in "subscription_email", with: "some_random_email@example.com"
      click_button "Save"
      wait_for_ajax
    }.to change(Storytime::Subscription, :count).by(1)

    subscription = Storytime::Subscription.last
    expect(subscription.email).to eq("some_random_email@example.com")
    expect(subscription.token).to_not eq(nil)
  end

  it "updates a subscription", js: true do
    subscription = FactoryGirl.create(:subscription)

    expect(Storytime::Subscription.count).to eq(1)
    expect(subscription.subscribed?).to eq(true)

    visit storytime.dashboard_path
    click_link "subscriptions-link"
    # wait_for_ajax
    click_link "edit-subscription-#{subscription.id}"
    fill_in "subscription_email", with: "johndoe@example.com"
    uncheck "subscription_subscribed"
    click_button "Save"

    wait_for_ajax

    subscription.reload

    expect(subscription.email).to eq("johndoe@example.com")
    expect(subscription.subscribed?).to eq(false)
  end
end