require 'spec_helper'

describe "Dashboard artifacts", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let!(:site) do
    s = FactoryBot.create(:site, custom_domain: "www.example.com")
    s.save_with_seeds(user); s
  end
  let(:host) { "http://www.example.com" }
  let(:html_file) { Rack::Test::UploadedFile.new(File.open("./spec/support/files/sample_artifact.html"), "text/html") }

  before { sign_in user }

  describe "POST create with expiration" do
    it "parses a datepicker date string into an end-of-day expiration" do
      post host + dashboard_artifacts_path,
           params: { artifact: { name: "Expiring", file: html_file, expires_at: "July 8, 2026" } }

      artifact = Storytime::Artifact.find_by(name: "Expiring")
      expect(artifact.expires_at).to be_within(1.second).of(Time.zone.parse("July 8, 2026").end_of_day)
    end

    it "treats a blank expiration as no expiration" do
      post host + dashboard_artifacts_path,
           params: { artifact: { name: "Forever", file: html_file, expires_at: "" } }

      expect(Storytime::Artifact.find_by(name: "Forever").expires_at).to be_nil
    end
  end

  describe "authorization" do
    it "forbids a non-admin member from creating artifacts" do
      writer = FactoryBot.create(:user)
      Storytime::Membership.create!(user: writer, site: site,
                                    storytime_role: Storytime::Role.find_by(name: "writer"))
      sign_in writer

      expect {
        post host + dashboard_artifacts_path,
             params: { artifact: { name: "Sneaky", file: html_file } }
      }.not_to change(Storytime::Artifact, :count)
    end
  end
end
