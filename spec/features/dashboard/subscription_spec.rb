require 'spec_helper'

describe "In the dashboard, Subscriptions" do
  before do
    login_admin
  end

  it "lists subscriptions" do
    3.times{ FactoryGirl.create(:subscription) }
    visit url_for([:dashboard, Storytime::Subscription])

    Storytime::Subscription.all.each do |s|
      expect(page).to have_link("Edit", href: url_for([:edit, :dashboard, s]))  
    end
  end

  it "creates a subscription" do
    expect(Storytime::Subscription.count).to eq(0)

    visit url_for([:new, :dashboard, :subscription, only_path: true])
    fill_in "subscription_email", with: "some_random_email@example.com"

    click_button "Create Subscription"

    expect(page).to have_content(I18n.t('flash.subscriptions.create.success'))
    expect(Storytime::Subscription.count).to eq(1)

    subscription = Storytime::Subscription.last

    expect(subscription.email).to eq("some_random_email@example.com")
    expect(subscription.token).to_not eq(nil)
  end

  it "updates a subscription" do
    subscription = FactoryGirl.create(:subscription)

    expect(Storytime::Subscription.count).to eq(1)
    expect(subscription.subscribed?).to eq(true)

    visit url_for([:edit, :dashboard, subscription])
    fill_in "subscription_email", with: "johndoe@example.com"
    uncheck "subscription_subscribed"
    click_button "Update Subscription"

    expect(page).to have_content(I18n.t('flash.subscriptions.update.success'))

    subscription.reload

    expect(subscription.email).to eq("johndoe@example.com")
    expect(subscription.subscribed?).to eq(false)
  end
end