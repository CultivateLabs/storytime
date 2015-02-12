module Storytime
  class PostNotifier
    def self.send_notifications_for(post_id)
      post = Storytime::Post.find_by(id: post_id)

      return if post.nil?

      unless post.notifications_sent_at
        post.update_attributes(notifications_sent_at: Time.now)

        post.site.active_email_subscriptions.each do |subscription|
          mail = Storytime::SubscriptionMailer.new_post_email(post, subscription)

          Rails::VERSION::MINOR < 2 ? mail.deliver : mail.deliver_now
        end
      end
    end
  end
end