require 'spec_helper'

# Request spec rather than controller spec so we go through the real engine
# routes – the bug only manifests after the route's PageConstraint admits the
# request to the controller.
describe "Pages", type: :request do
  let(:user) { FactoryBot.create(:admin) }
  let!(:site) do
    s = FactoryBot.create(:site, custom_domain: "www.example.com")
    s.save_with_seeds(user)
    s
  end

  before do
    # Force the route's PageConstraint to admit the request so we can exercise
    # the controller for ids the constraint would normally reject (like the
    # leading-slash slugs that bots probe).
    allow_any_instance_of(Storytime::Constraints::PageConstraint)
      .to receive(:matches?).and_return(true)
  end

  describe "GET /:id when no page or slug-specific template matches" do
    it "404s instead of falling through to a show template that requires @page" do
      get "http://www.example.com/no-such-page"
      expect(response).to have_http_status(:not_found)
    end

    it "404s for malformed ids with a leading slash" do
      # Bots hit URL-encoded paths like /%2Fcontact. The PageConstraint can let
      # these through because POSIX collapses // in File.exist?, but the
      # template resolver does not, so the controller must 404 explicitly
      # rather than rendering the @page-dependent show template.
      get "http://www.example.com/%2Fno-such-page"
      expect(response).to have_http_status(:not_found)
    end
  end
end
