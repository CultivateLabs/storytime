module Storytime
  module Dashboard
    module SitesHelper
      def post_slug_style_options
        [
          ["Default - e.g. /posts/post-title", :default],
          ["Day and Name - e.g. /1985/06/09/post-title", :day_and_name], 
          ["Month and Name - e.g. /1985/06/post-title", :month_and_name], 
          ["Post ID - e.g. /posts/123", :post_id], 
        ]
      end
    end
  end
end
