require_dependency "storytime/application_controller"

module Storytime
  class HomepageController < PagesController
  private
    def load_page
      @page = @site.homepage
    end
  end
end