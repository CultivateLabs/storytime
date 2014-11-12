module Storytime
  module SubscriptionsHelper
    def subscription_label(subscription)
      status_label = subscription.subscribed ? "label-info" : "label-warning" 
      status = subscription.subscribed ? "Subscribed" : "Unsubscribed" 

      "<label class='label #{status_label}'>#{status}</label>".html_safe
    end
  end
end
