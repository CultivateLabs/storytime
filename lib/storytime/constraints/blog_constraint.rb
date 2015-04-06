module Storytime
  module Constraints
    class BlogConstraint
      include Storytime::Concerns::CurrentSite
      
      def matches?(request)
        current_storytime_site(request).blogs.friendly.exists?(request.params[:id])
      end
    end
  end
end