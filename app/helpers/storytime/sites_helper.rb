module Storytime
  module SitesHelper
    def post_slug_style_options
      [
        ["Default - e.g. /posts/123", :default], 
        ["Day and Name - e.g. /1985/06/09/post-title", :day_and_name], 
        ["Month and Name - e.g. /1985/06/post-title", :month_and_name], 
        ["Post Name - e.g. /post-title", :post_name]
      ]
    end

    def root_page_content_options
      [
        ["Blog Posts", :posts], 
        ["Page", :page]
      ]
    end
  end
end
