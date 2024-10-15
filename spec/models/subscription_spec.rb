require 'spec_helper'

describe Storytime::Subscription do
  describe "generate_token" do
    it "generates a token before creation" do
      subscription = FactoryBot.build(:subscription)

      expect(subscription.token).to eq(nil)

      subscription.save

      expect(subscription.token).to_not eq(nil)
    end

    it "generates a token that can be regenerated from the email" do
      subscription = FactoryBot.create(:subscription)
      token = subscription.token

      key = ENV["SECRET_KEY_BASE"]
      digest = OpenSSL::Digest.new('sha1')
      regenerated_token = OpenSSL::HMAC.hexdigest(digest, key, subscription.email)

      expect(token).to eq(regenerated_token)
    end
  end

  describe "unsubscribe!" do
    it "sets subscribed to false" do
      subscription = FactoryBot.create(:subscription)

      expect(subscription.subscribed?).to eq(true)

      subscription.unsubscribe!

      expect(subscription.subscribed?).to eq(false)
    end
  end
end