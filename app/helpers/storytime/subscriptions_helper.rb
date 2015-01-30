module Storytime
  module SubscriptionsHelper
    def subscription_label(subscription)
      status_label = subscription.subscribed ? "label-info" : "label-warning" 
      status = subscription.subscribed ? "Subscribed" : "Unsubscribed" 

      "<label class='label #{status_label}'>#{status}</label>".html_safe
    end

    def storytime_email_subscription_form(site=Storytime::Site.last)
      @storytime_site = site
      
      render "storytime/subscriptions/form"
    end
  end
end
