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
    it "serves a sandboxed iframe wrapper, not the raw content, with a noindex header" do
      artifact = create_artifact(content: "<html><body>Live artifact</body></html>")

      get "http://www.example.com/a/#{artifact.token}"

      expect(response).to have_http_status(:ok)
      # The wrapper embeds the content in a sandbox WITHOUT allow-same-origin.
      expect(response.body).to include("iframe")
      expect(response.body).to include("/a/#{artifact.token}/raw")
      expect(response.body).to match(/sandbox="[^"]*allow-scripts/)
      expect(response.body).not_to include('allow-same-origin')
      # The artifact markup is not inlined on the app origin.
      expect(response.body).not_to include("Live artifact")
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

  describe "GET /a/:token/raw" do
    it "serves the artifact HTML with sandbox and hardening headers" do
      artifact = create_artifact(content: "<html><body>Live artifact</body></html>")

      get "http://www.example.com/a/#{artifact.token}/raw"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Live artifact")
      expect(response.media_type).to eq("text/html")
      expect(response.headers["Content-Security-Policy"]).to match(/\Asandbox .*allow-scripts/)
      expect(response.headers["Content-Security-Policy"]).not_to include("allow-same-origin")
      expect(response.headers["X-Content-Type-Options"]).to eq("nosniff")
      expect(response.headers["X-Robots-Tag"]).to include("noindex")
    end

    it "404s the raw content while the artifact is still locked" do
      artifact = create_artifact(content: "<html>secret content</html>", password: "letmein")

      get "http://www.example.com/a/#{artifact.token}/raw"

      expect(response).to have_http_status(:not_found)
      expect(response.body).not_to include("secret content")
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
      # The wrapper now renders; the content is reachable via the raw endpoint.
      expect(response.body).to include("iframe")

      get "http://www.example.com/a/#{artifact.token}/raw"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("secret content")
    end

    it "throttles repeated incorrect password attempts" do
      # Use a real cache store so the attempt counter persists across requests,
      # regardless of the host app's configured cache.
      allow(Rails).to receive(:cache).and_return(ActiveSupport::Cache::MemoryStore.new)
      artifact = create_artifact(password: "letmein")

      Storytime::ArtifactsController::MAX_UNLOCK_ATTEMPTS.times do
        post "http://www.example.com/a/#{artifact.token}/unlock", params: { password: "wrong" }
        expect(response).to have_http_status(:unauthorized)
      end

      # Further attempts are refused even with the correct password.
      post "http://www.example.com/a/#{artifact.token}/unlock", params: { password: "letmein" }
      expect(response).to have_http_status(:too_many_requests)
      expect(response.body).to include("Too many attempts")
    end

    it "revokes an existing session unlock when the password changes" do
      artifact = create_artifact(content: "<html>secret content</html>", password: "letmein")

      post "http://www.example.com/a/#{artifact.token}/unlock", params: { password: "letmein" }
      get "http://www.example.com/a/#{artifact.token}/raw"
      expect(response.body).to include("secret content")

      # Rotate the password; the earlier session unlock must no longer apply.
      artifact.update!(password: "newsecret")

      get "http://www.example.com/a/#{artifact.token}"
      expect(response.body).to include("Password required")

      get "http://www.example.com/a/#{artifact.token}/raw"
      expect(response).to have_http_status(:not_found)
      expect(response.body).not_to include("secret content")
    end
  end
end
