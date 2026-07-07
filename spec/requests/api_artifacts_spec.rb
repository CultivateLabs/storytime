require 'spec_helper'

describe "Artifacts API", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let!(:site) do
    s = FactoryBot.create(:site, custom_domain: "www.example.com")
    s.save_with_seeds(user)
    s
  end

  let(:api_token) { "test-api-token" }
  let(:auth_headers) { { "Authorization" => "Bearer #{api_token}" } }

  around do |example|
    original = Storytime.artifacts_api_token
    Storytime.artifacts_api_token = api_token
    example.run
    Storytime.artifacts_api_token = original
  end

  describe "authentication" do
    it "rejects requests without a valid token" do
      post "http://www.example.com/api/v1/artifacts",
           params: { name: "X", html: "<html>hi</html>" }
      expect(response).to have_http_status(:unauthorized)
    end

    it "rejects requests with the wrong token" do
      post "http://www.example.com/api/v1/artifacts",
           params: { name: "X", html: "<html>hi</html>" },
           headers: { "Authorization" => "Bearer nope" }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "POST /api/v1/artifacts" do
    it "creates an artifact from raw html and returns the token url" do
      post "http://www.example.com/api/v1/artifacts",
           params: { name: "From API", html: "<html>api body</html>", password: "pw", expires_at: 1.day.from_now.iso8601 },
           headers: auth_headers

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["token"]).to be_present
      expect(json["url"]).to include("/a/#{json['token']}")
      expect(json["password_protected"]).to eq(true)

      artifact = Storytime::Artifact.find_by(token: json["token"])
      expect(artifact.content).to eq("<html>api body</html>")
      expect(artifact.authenticate("pw")).to be_truthy
    end

    it "returns errors when content is missing" do
      post "http://www.example.com/api/v1/artifacts",
           params: { name: "No content" },
           headers: auth_headers
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /api/v1/artifacts/:token" do
    it "replaces the content" do
      artifact = FactoryBot.create(:artifact, site: site, user: user, content: "<html>old</html>")

      patch "http://www.example.com/api/v1/artifacts/#{artifact.token}",
            params: { html: "<html>new</html>" },
            headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(artifact.reload.content).to eq("<html>new</html>")
    end
  end

  describe "DELETE /api/v1/artifacts/:token" do
    it "deletes the artifact" do
      artifact = FactoryBot.create(:artifact, site: site, user: user)

      delete "http://www.example.com/api/v1/artifacts/#{artifact.token}", headers: auth_headers

      expect(response).to have_http_status(:no_content)
      expect(Storytime::Artifact.find_by(token: artifact.token)).to be_nil
    end
  end
end
