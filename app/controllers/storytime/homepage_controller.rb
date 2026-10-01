require_dependency "storytime/application_controller"

module Storytime
  class HomepageController < PagesController
  private
    def load_page
      @page = load_public_post(current_storytime_site.root_post_id, scope: current_storytime_site.posts)
    end
  end
end