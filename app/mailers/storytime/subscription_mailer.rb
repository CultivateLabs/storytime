module Storytime
  class SubscriptionMailer < ActionMailer::Base
    default from: Storytime.subscription_email_from

    def new_post_email(post, subscription)
      @post = post
      @subscription = subscription
      @site = subscription.site

      mail(to: @subscription.email, subject: "New Post from #{@site.title}")
    end
  end
end
