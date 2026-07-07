require 'spec_helper'

describe "Dashboard API tokens", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let!(:site) do
    s = FactoryBot.create(:site, custom_domain: "www.example.com")
    s.save_with_seeds(user)
    s
  end

  let(:host) { "http://www.example.com" }

  before { sign_in user }

  describe "GET index" do
    it "lists existing tokens" do
      FactoryBot.create(:api_token, site: site, user: user, name: "Existing Token")

      get host + dashboard_api_tokens_path(format: :json)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Existing Token")
    end
  end

  describe "POST create" do
    it "creates a token and surfaces the raw value once" do
      expect {
        post host + dashboard_api_tokens_path(format: :json),
             params: { api_token: { name: "New Token" } }
      }.to change(Storytime::ApiToken, :count).by(1)

      expect(response).to have_http_status(:ok)
      token = Storytime::ApiToken.order(:created_at).last
      expect(token.user).to eq(user)
      expect(token.name).to eq("New Token")
      # The raw token is rendered once in the returned HTML (we can only assert
      # on the stored prefix, since the full raw value is never persisted).
      expect(response.body).to include(token.token_prefix)
      expect(response.body).to include("Copy your new token now")
    end

    it "rejects a blank name" do
      post host + dashboard_api_tokens_path(format: :json),
           params: { api_token: { name: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "parses a datepicker date string into an end-of-day expiration" do
      post host + dashboard_api_tokens_path(format: :json),
           params: { api_token: { name: "Expiring", expires_at: "July 8, 2026" } }

      token = Storytime::ApiToken.order(:created_at).last
      expect(token.expires_at).to be_within(1.second).of(Time.zone.parse("July 8, 2026").end_of_day)
    end

    it "treats a blank expiration as no expiration" do
      post host + dashboard_api_tokens_path(format: :json),
           params: { api_token: { name: "Forever", expires_at: "" } }

      expect(Storytime::ApiToken.order(:created_at).last.expires_at).to be_nil
    end
  end

  describe "DELETE destroy" do
    it "deletes the token" do
      token = FactoryBot.create(:api_token, site: site, user: user)

      expect {
        delete host + dashboard_api_token_path(token, format: :json)
      }.to change(Storytime::ApiToken, :count).by(-1)
    end
  end
end
