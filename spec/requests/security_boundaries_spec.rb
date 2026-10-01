require "spec_helper"

RSpec.describe "CMS security boundaries", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:admin) { Storytime.user_class.create!(email: "admin@example.invalid", password: "test-password") }
  let(:writer) { Storytime.user_class.create!(email: "writer@example.invalid", password: "test-password") }
  let(:outsider) { Storytime.user_class.create!(email: "outsider@example.invalid", password: "test-password") }
  let(:victim) { Storytime.user_class.create!(email: "victim@example.invalid", password: "test-password") }
  let!(:site) { create_site("www.example.com", admin) }
  let!(:other_site) { create_site("other.example.com", victim) }
  let(:dashboard) { Storytime.dashboard_namespace_path }

  def create_site(host, user)
    Storytime::Site.create!(title: host, custom_domain: host, creator: user,
                           subscription_email_from: "site@example.invalid", layout: "storytime/application")
  end

  def membership(user, role, target = site)
    Storytime::Membership.create!(user: user, site: target, storytime_role: Storytime::Role.find_by!(name: role))
  end

  def page_for(user, target = site, **attributes)
    previous_site_id = Storytime::Site.current_id
    Storytime::Site.current_id = target.id
    Storytime::Page.create!({ user: user, site: target, title: "Page #{SecureRandom.hex(5)}",
                             draft_content: "Private draft", draft_user_id: user.id }.merge(attributes))
  ensure
    Storytime::Site.current_id = previous_site_id
  end

  around do |example|
    previous = Rails.application.env_config["action_dispatch.show_exceptions"]
    example.run
  ensure
    Rails.application.env_config["action_dispatch.show_exceptions"] = previous
  end

  before do
    Storytime::Site.setup_seeds
    membership(admin, "admin")
    membership(writer, "writer")
    membership(victim, "admin", other_site)
    host! site.custom_domain
    Rails.application.env_config["action_dispatch.show_exceptions"] = :rescuable
  end

  after { Storytime::Site.current_id = nil }

  describe "global account identities" do
    before { sign_in admin }

    it "does not let a tenant admin attach another global account" do
      expect {
        post "#{dashboard}/memberships", params: { membership: { user_id: victim.id, storytime_role_id: Storytime::Role.find_by!(name: "writer").id } }, as: :json
      }.not_to change(Storytime::Membership, :count)
      expect(victim.reload.email).to eq("victim@example.invalid")
    end

    it "changes a shared user's local role without changing their global identity" do
      shared = membership(victim, "writer")
      editor = Storytime::Role.find_by!(name: "editor")
      patch "#{dashboard}/memberships/#{shared.id}", params: { membership: {
        storytime_role_id: editor.id, user_id: outsider.id,
        user_attributes: { email: "attacker@example.invalid", storytime_name: "Changed", password: "changed-password" }
      } }, as: :json
      expect(response).to have_http_status(:ok)
      expect(shared.reload.storytime_role).to eq(editor)
      expect(shared.user).to eq(victim)
      expect(victim.reload.email).to eq("victim@example.invalid")
      expect(victim.valid_password?("test-password")).to be(true)
      expect(victim.storytime_name).not_to eq("Changed")
    end

    it "still provisions a new account with a membership on the current site" do
      post "#{dashboard}/memberships", params: { user: { email: "new@example.invalid", password: "test-password",
        password_confirmation: "test-password", storytime_memberships_attributes: { "0" => { storytime_role_id: Storytime::Role.find_by!(name: "writer").id } } } }, as: :json
      expect(response).to have_http_status(:ok)
      user = Storytime.user_class.find_by!(email: "new@example.invalid")
      expect(user.storytime_memberships.find_by(site: site)).to be_present
    end
  end

  describe "site administration" do
    before { sign_in admin }

    it "rejects reading, changing and deleting a different site" do
      get "#{dashboard}/sites/#{other_site.id}/edit", as: :json
      expect(response).to have_http_status(:not_found)
      sign_in admin
      patch "#{dashboard}/sites/#{other_site.id}", params: { site: { title: "Hijacked" } }, as: :json
      expect(response).to have_http_status(:not_found)
      expect(other_site.reload.title).not_to eq("Hijacked")
      sign_in admin
      delete "#{dashboard}/sites/#{other_site.id}", as: :json
      expect(response).to have_http_status(:not_found)
      expect(Storytime::Site.exists?(other_site.id)).to be(true)
    end

    it "allows an admin to edit their own site" do
      patch "#{dashboard}/sites/#{site.id}", params: { site: { title: "Renamed" } }, as: :json
      expect(response).to have_http_status(:ok)
      expect(site.reload.title).to eq("Renamed")
    end

    it "does not grant writers or tenant admins site provisioning privileges" do
      [writer, admin].each do |user|
        sign_in user
        expect {
          post "#{dashboard}/sites", params: { site: { title: "New site", custom_domain: "new.example.com", subscription_email_from: "site@example.invalid" } }
        }.not_to change(Storytime::Site, :count)
      end
    end

    it "allows explicit global provisioning and restores tenant scope" do
      allow(Storytime).to receive(:site_creation_authorizer).and_return(->(user) { user == admin })
      post "#{dashboard}/sites", params: { site: { title: "New site", custom_domain: "new.example.com", subscription_email_from: "site@example.invalid" } }
      expect(response).to have_http_status(:redirect)
      created = Storytime::Site.find_by!(custom_domain: "new.example.com")
      expect(admin.storytime_admin?(created)).to be(true)
      expect(created.homepage.site_id).to eq(created.id)
      expect(Storytime::Site.current_id).to be_nil
    end

    it "rolls back provisioning when a seeded record fails and restores the old site scope" do
      Storytime::Site.current_id = site.id
      counts = [Storytime::Site.count, Storytime::Membership.unscoped.count, Storytime::Permission.unscoped.count]
      new_site = Storytime::Site.new(title: "Failed site", custom_domain: "failed.example.com", subscription_email_from: "site@example.invalid")
      allow(Storytime::Blog).to receive(:seed).and_return(Storytime::Blog.new)
      expect { new_site.save_with_seeds(admin) }.to raise_error(ActiveRecord::RecordInvalid)
      expect([Storytime::Site.count, Storytime::Membership.unscoped.count, Storytime::Permission.unscoped.count]).to eq(counts)
      expect(Storytime::Site.current_id).to eq(site.id)
    end

    it "normalizes domains before checking uniqueness" do
      duplicate = Storytime::Site.new(title: "Duplicate", custom_domain: "https://#{site.custom_domain}", creator: admin, subscription_email_from: "site@example.invalid")
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:custom_domain]).to be_present
    end
  end

  describe "previews and homepages" do
    let!(:page) { page_for(admin) }

    it "denies unpublished pages to anonymous users, non-members and other writers" do
      get "/#{page.slug}", params: { preview: true }
      expect(response).to have_http_status(:not_found)
      [outsider, writer].each do |user|
        sign_in user
        get "/#{page.slug}", params: { preview: true }
        expect(response).to have_http_status(:redirect)
        expect(response.body).not_to include("Private draft")
      end
    end

    it "allows owners and editors to preview with or without an autosave" do
      sign_in admin
      get "/#{page.slug}", params: { preview: true }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Private draft")
      membership(outsider, "editor")
      page.create_autosave!(draft_content: "Autosaved content", site_id: site.id)
      sign_in outsider
      get "/#{page.slug}", params: { preview: true }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Autosaved content")
    end

    it "denies previews to a removed author" do
      owned = page_for(writer)
      writer.storytime_memberships.destroy_all
      sign_in writer
      get "/#{owned.slug}", params: { preview: true }
      expect(response).to have_http_status(:redirect)
      expect(response.body).not_to include("Private draft")
    end

    it "hides draft and scheduled homepages from anonymous readers" do
      page.update!(published_at: 1.minute.ago)
      site.update!(root_post_id: page.id)
      [nil, 1.day.from_now].each do |time|
        page.update!(published_at: time)
        get "/"
        expect(response).to have_http_status(:not_found)
        end
      sign_in admin
      get "/", params: { preview: true }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Private draft")
    end

    it "serves published homepages and rejects foreign or draft homepage selections" do
      page.update!(published_at: 1.minute.ago)
      expect(site.update(root_post_id: page.id)).to be(true)
      get "/"
      expect(response).to have_http_status(:ok)
      foreign = page_for(victim, other_site, published_at: 1.minute.ago)
      expect(site.update(root_post_id: foreign.id)).to be(false)
      draft = page_for(admin)
      expect(site.update(root_post_id: draft.id)).to be(false)
    end

    it "authorizes blog previews even when no autosave exists" do
      blog = Storytime::Blog.create!(site: site, user: admin, title: "Draft blog", draft_content: "Private blog", draft_user_id: admin.id)
      sign_in outsider
      get "/#{blog.slug}", params: { preview: true }
      expect(response).to have_http_status(:redirect)
      sign_in admin
      get "/#{blog.slug}", params: { preview: true }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "version activation" do
    let!(:own_page) { page_for(writer) }
    before { sign_in writer }

    it "rejects a version from another post and rolls back the attempted update" do
      [page_for(admin), page_for(writer), page_for(victim, other_site)].each do |source|
        sign_in writer
        patch "#{dashboard}/pages/#{own_page.id}", params: { page: { title: "Should roll back", draft_version_id: source.versions.first.id } }
        expect(response).to have_http_status(:not_found)
        expect(own_page.reload.title).not_to eq("Should roll back")
        expect(own_page.content).to be_nil
      end
    end

    it "allows a version belonging to the edited post" do
      version = own_page.versions.first
      patch "#{dashboard}/pages/#{own_page.id}", params: { page: { draft_version_id: version.id } }
      expect(response).to have_http_status(:redirect)
      expect(own_page.reload.content).to eq(version.content)
    end
  end

  describe "media deletion" do
    it "allows owners and editors but refuses other writers" do
      media = Storytime::Media.create!(site: site, user: admin)
      sign_in writer
      delete "#{dashboard}/media/#{media.id}", as: :json
      expect(Storytime::Media.exists?(media.id)).to be(true)
      membership(outsider, "editor")
      sign_in outsider
      delete "#{dashboard}/media/#{media.id}", as: :json
      expect(response).to have_http_status(:no_content)
      own = Storytime::Media.create!(site: site, user: writer)
      sign_in writer
      delete "#{dashboard}/media/#{own.id}", as: :json
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "media uploads" do
    before { sign_in admin }

    def upload(contents, name, type)
      Tempfile.create(["security-upload", File.extname(name)]) do |file|
        file.binmode
        file.write(contents)
        file.flush
        input = Rack::Test::UploadedFile.new(file.path, type, true, original_filename: name)
        post "#{dashboard}/media", params: { media: { file: input } }
      end
    end

    it "rejects active file types even when they claim to be JPEGs" do
      ["payload.svg", "payload.jpg"].each do |name|
        expect {
          upload('<svg xmlns="http://www.w3.org/2000/svg"><script>alert(1)</script></svg>', name, "image/jpeg")
        }.not_to change(Storytime::Media, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    it "rejects oversized image uploads" do
      jpeg = File.binread(Storytime::Engine.root.join("spec/support/images/success-kid.jpg"))
      expect {
        upload(jpeg + ("x" * 10.megabytes), "large.jpg", "image/jpeg")
      }.not_to change(Storytime::Media, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "autosaves" do
    let!(:page) { page_for(admin) }
    let!(:autosave) { page.create_autosave!(draft_content: "Keep this draft", site_id: site.id) }

    it "preserves another author's autosave when a writer tries to replace it" do
      sign_in writer
      post "#{dashboard}/pages/#{page.id}/autosaves", params: { page: { draft_content: "Unauthorized" } }
      expect(response).to have_http_status(:redirect)
      expect(autosave.reload.content).to eq("Keep this draft")
    end

    it "updates an authorized autosave in place and can create a missing one" do
      sign_in admin
      post "#{dashboard}/pages/#{page.id}/autosaves", params: { page: { draft_content: "Updated" } }
      expect(response).to have_http_status(:ok)
      expect(page.reload.autosave.id).to eq(autosave.id)
      expect(autosave.reload.content).to eq("Updated")
      autosave.destroy!
      post "#{dashboard}/pages/#{page.id}/autosaves", params: { page: { draft_content: "New autosave" } }
      expect(response).to have_http_status(:ok)
      expect(page.reload.autosave.content).to eq("New autosave")
    end

    it "reports validation failures without losing the previous autosave" do
      sign_in admin
      allow_any_instance_of(Storytime::Autosave).to receive(:valid?).and_return(false)
      post "#{dashboard}/pages/#{page.id}/autosaves", params: { page: { draft_content: "Invalid" } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(autosave.reload.content).to eq("Keep this draft")
    end
  end
end
