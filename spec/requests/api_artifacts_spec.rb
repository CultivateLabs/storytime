require 'spec_helper'

describe "Artifacts API", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let!(:site) do
    s = FactoryBot.create(:site, custom_domain: "www.example.com")
    s.save_with_seeds(user)
    s
  end

  let!(:token_record) { FactoryBot.create(:api_token, site: site, user: user) }
  let(:raw_token) { token_record.raw_token }
  let(:auth_headers) { { "Authorization" => "Bearer #{raw_token}" } }

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

    it "does not accept the token from a query parameter (header only)" do
      post "http://www.example.com/api/v1/artifacts?api_token=#{raw_token}",
           params: { name: "X", html: "<html>hi</html>" }
      expect(response).to have_http_status(:unauthorized)
      expect(Storytime::Artifact.unscoped.where(name: "X")).to be_empty
    end

    it "rejects a valid token minted for a different site" do
      other_site = FactoryBot.create(:site, custom_domain: "other.example.com")
      other_site.save_with_seeds(FactoryBot.create(:user))
      other_token = FactoryBot.create(:api_token, site: other_site, user: user)

      post "http://www.example.com/api/v1/artifacts",
           params: { name: "Cross", html: "<html>x</html>" },
           headers: { "Authorization" => "Bearer #{other_token.raw_token}" }

      expect(response).to have_http_status(:unauthorized)
      expect(Storytime::Artifact.unscoped.where(name: "Cross")).to be_empty
    end

    it "rejects a token whose owner lacks artifact-manage rights on the site" do
      writer = FactoryBot.create(:user)
      Storytime::Membership.create!(user: writer, site: site,
                                    storytime_role: Storytime::Role.find_by(name: "writer"))
      writer_token = FactoryBot.create(:api_token, site: site, user: writer)

      post "http://www.example.com/api/v1/artifacts",
           params: { name: "ByWriter", html: "<html>x</html>" },
           headers: { "Authorization" => "Bearer #{writer_token.raw_token}" }

      expect(response).to have_http_status(:unauthorized)
      expect(Storytime::Artifact.unscoped.where(name: "ByWriter")).to be_empty
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
      expect(artifact.user).to eq(user)
    end

    it "stamps the token's last_used_at" do
      post "http://www.example.com/api/v1/artifacts",
           params: { name: "X", html: "<html>hi</html>" },
           headers: auth_headers
      expect(token_record.reload.last_used_at).to be_present
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
