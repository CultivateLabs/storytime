require_dependency "storytime/application_controller"

module Storytime
  class BlogHomepageController < BlogsController
  private
    def load_page
      @page = @current_storytime_site.homepage
    end
  end
end