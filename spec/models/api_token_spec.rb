require 'spec_helper'

module Storytime
  describe ApiToken, type: :model do
    it "is valid with a name" do
      expect(FactoryBot.build(:api_token, name: "CI")).to be_valid
    end

    it "requires a name" do
      expect(FactoryBot.build(:api_token, name: nil)).not_to be_valid
    end

    describe "token generation" do
      it "exposes the raw token once, prefixed with sk_" do
        token = FactoryBot.create(:api_token)
        expect(token.raw_token).to start_with("sk_")
        expect(token.raw_token.length).to be >= 40
      end

      it "stores only a digest, never the raw token" do
        token = FactoryBot.create(:api_token)
        raw = token.raw_token
        expect(token.token_digest).to eq(Storytime::ApiToken.digest(raw))
        expect(token.token_digest).not_to eq(raw)
        # reloading does not resurface the raw token
        expect(Storytime::ApiToken.find(token.id).raw_token).to be_nil
      end

      it "records a display prefix" do
        token = FactoryBot.create(:api_token)
        expect(token.token_prefix).to eq(token.raw_token[0, 11])
      end
    end

    describe ".authenticate" do
      it "returns the token for the correct raw value" do
        token = FactoryBot.create(:api_token)
        expect(Storytime::ApiToken.authenticate(token.raw_token)).to eq(token)
      end

      it "returns nil for an unknown value" do
        FactoryBot.create(:api_token)
        expect(Storytime::ApiToken.authenticate("sk_nope")).to be_nil
      end

      it "returns nil for a blank value" do
        expect(Storytime::ApiToken.authenticate("")).to be_nil
        expect(Storytime::ApiToken.authenticate(nil)).to be_nil
      end

      it "returns nil for an expired token" do
        token = FactoryBot.create(:api_token, expires_at: 1.hour.ago)
        expect(Storytime::ApiToken.authenticate(token.raw_token)).to be_nil
      end

      it "authenticates regardless of the current site scope" do
        site_a = FactoryBot.create(:site)
        token = nil
        Storytime::Site.current_id = site_a.id
        begin
          token = FactoryBot.create(:api_token, site: site_a)
        ensure
          Storytime::Site.current_id = nil
        end
        expect(Storytime::ApiToken.authenticate(token.raw_token)).to eq(token)
      end
    end

    describe "#touch_last_used!" do
      it "stamps last_used_at" do
        token = FactoryBot.create(:api_token, last_used_at: nil)
        token.touch_last_used!
        expect(token.reload.last_used_at).to be_present
      end
    end
  end
end
