module Storytime
  class SubscriptionMailer < ActionMailer::Base
    def new_post_email(post, subscription)
      @post = post
      @subscription = subscription
      @site = subscription.site

      mail(to: @subscription.email, from: @site.subscription_email_from, subject: "New Post from #{@site.title}")
    end
  end
end
