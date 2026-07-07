require 'spec_helper'

describe "Artifacts (public serving)", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let!(:site) do
    s = FactoryBot.create(:site, custom_domain: "www.example.com")
    s.save_with_seeds(user)
    s
  end

  def create_artifact(**attrs)
    FactoryBot.create(:artifact, { site: site, user: user }.merge(attrs))
  end

  describe "GET /a/:token" do
    it "serves the artifact HTML with a noindex header" do
      artifact = create_artifact(content: "<html><body>Live artifact</body></html>")

      get "http://www.example.com/a/#{artifact.token}"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Live artifact")
      expect(response.media_type).to eq("text/html")
      expect(response.headers["X-Robots-Tag"]).to include("noindex")
    end

    it "404s for an unknown token" do
      get "http://www.example.com/a/does-not-exist"
      expect(response).to have_http_status(:not_found)
    end

    it "404s for an expired artifact" do
      artifact = create_artifact(expires_at: 1.hour.ago)
      get "http://www.example.com/a/#{artifact.token}"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "password gating" do
    it "shows the password form instead of the content when locked" do
      artifact = create_artifact(content: "<html>secret content</html>", password: "letmein")

      get "http://www.example.com/a/#{artifact.token}"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Password required")
      expect(response.body).not_to include("secret content")
    end

    it "rejects an incorrect password" do
      artifact = create_artifact(password: "letmein")

      post "http://www.example.com/a/#{artifact.token}/unlock", params: { password: "wrong" }

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include("Incorrect password")
    end

    it "unlocks for the session with the correct password" do
      artifact = create_artifact(content: "<html>secret content</html>", password: "letmein")

      post "http://www.example.com/a/#{artifact.token}/unlock", params: { password: "letmein" }
      expect(response).to redirect_to("/a/#{artifact.token}")

      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("secret content")
    end
  end
end
