require_dependency "storytime/application_controller"

module Storytime
  class BlogHomepageController < BlogsController
  private
    def load_page
      @page = @site.homepage
    end
  end
end