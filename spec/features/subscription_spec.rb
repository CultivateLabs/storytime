require 'spec_helper'

describe "Subscriptions" do
  before do
    setup_site
  end

  it "allows users to subscribe to a site" do
    pending "test if user can find a link to subscribe, click the link, enter their email, and then get a confirmation"
  end

  it "allows users to unsubscribe from a site through a link" do
    pending "test if user can goto a link and unsubscribe from a site"
  end

  it "only allows users to unsubscribe with a proper token" do
    pending "test if user can unsubscribe with incorrect token"
  end
end