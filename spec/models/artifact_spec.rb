require 'spec_helper'

module Storytime
  describe Artifact, type: :model do
    it "is valid with a name and content" do
      expect(FactoryBot.build(:artifact)).to be_valid
    end

    it "requires a name" do
      artifact = FactoryBot.build(:artifact, name: nil)
      expect(artifact).not_to be_valid
    end

    it "requires content" do
      artifact = FactoryBot.build(:artifact, content: nil)
      expect(artifact).not_to be_valid
    end

    describe "token" do
      it "generates a long unguessable alphanumeric token on create" do
        artifact = FactoryBot.create(:artifact)
        expect(artifact.token).to be_present
        expect(artifact.token.length).to be >= 30
        expect(artifact.token).to match(/\A[A-Za-z0-9]+\z/)
      end

      it "does not overwrite an existing token" do
        artifact = FactoryBot.create(:artifact, token: "my-custom-token")
        expect(artifact.token).to eq("my-custom-token")
      end

      it "uses the token as the param" do
        artifact = FactoryBot.create(:artifact)
        expect(artifact.to_param).to eq(artifact.token)
      end
    end

    describe "#assign_html" do
      it "stores a raw string and records byte size" do
        artifact = Artifact.new(name: "x")
        artifact.assign_html("<html>hi</html>", filename: "page.html")
        expect(artifact.content).to eq("<html>hi</html>")
        expect(artifact.byte_size).to eq("<html>hi</html>".bytesize)
        expect(artifact.content_type).to eq("text/html")
        expect(artifact.original_filename).to eq("page.html")
      end

      it "reads from an IO-like object" do
        artifact = Artifact.new(name: "x")
        artifact.assign_html(StringIO.new("<html>io</html>"))
        expect(artifact.content).to eq("<html>io</html>")
      end
    end

    describe "password protection" do
      it "is not protected without a password" do
        expect(FactoryBot.create(:artifact)).not_to be_password_protected
      end

      it "is protected and authenticates once a password is set" do
        artifact = FactoryBot.create(:artifact, password: "secret")
        expect(artifact).to be_password_protected
        expect(artifact.authenticate("secret")).to be_truthy
        expect(artifact.authenticate("wrong")).to be_falsey
      end
    end

    describe "expiration" do
      it "is not expired when expires_at is nil" do
        expect(FactoryBot.create(:artifact, expires_at: nil)).not_to be_expired
      end

      it "is expired when expires_at is in the past" do
        expect(FactoryBot.create(:artifact, expires_at: 1.hour.ago)).to be_expired
      end

      it "is not expired when expires_at is in the future" do
        expect(FactoryBot.create(:artifact, expires_at: 1.hour.from_now)).not_to be_expired
      end

      it "excludes expired records from the active scope" do
        active = FactoryBot.create(:artifact)
        future = FactoryBot.create(:artifact, expires_at: 1.hour.from_now)
        FactoryBot.create(:artifact, expires_at: 1.hour.ago)
        expect(Artifact.active).to match_array([active, future])
      end
    end
  end
end
