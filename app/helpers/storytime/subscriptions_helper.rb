module Storytime
  module SubscriptionsHelper
    def storytime_email_subscription_form(site=Storytime::Site.last)
      @storytime_site = site
      
      render "storytime/subscriptions/form"
    end
  end
end
