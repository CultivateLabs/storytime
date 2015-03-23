require 'spec_helper'

describe "Subscriptions" do
  before do
    setup_site(FactoryGirl.create(:admin))
  end

  it "allows users to subscribe to a site" do
    expect(Storytime::Subscription.count).to eq(0)

    site = Storytime::Site.last
    email_address = "some_email_address@example.com"

    visit "/"
    click_link "#{I18n.t('layout.subscribe_to', site_name: site.title)}"
    fill_in "subscription_email", with: email_address
    click_button "Subscribe"

    expect(Storytime::Subscription.count).to eq(1)
    subscription = Storytime::Subscription.first

    expect(subscription.email).to eq(email_address)
    expect(subscription.token).to_not eq(nil)
    expect(subscription.subscribed?).to eq(true)
  end

  it "only allows users to unsubscribe with a proper token" do
    subscription_1 = FactoryGirl.create(:subscription, site: @current_site)
    token_1 = subscription_1.token

    subscription_2 = FactoryGirl.create(:subscription, site: @current_site)
    token_2 = subscription_2.token

    visit url_for([:unsubscribe_mailing_list, {:email => subscription_1.email, :t => token_2}])

    expect(page).to have_content(I18n.t('flash.subscriptions.destroy.fail'))
    expect(subscription_1.subscribed?).to eq(true)

    visit url_for([:unsubscribe_mailing_list, {:email => subscription_1.email, :t => token_1}])

    expect(page).to have_content(I18n.t('flash.subscriptions.destroy.success'))

    subscription_1.reload
    subscription_2.reload

    expect(subscription_1.subscribed?).to eq(false)
    expect(subscription_2.subscribed?).to eq(true)
  end
end