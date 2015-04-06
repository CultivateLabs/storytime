module Storytime
  module Constraints
    class PageConstraint
      include Storytime::Concerns::CurrentSite
      
      def matches?(request)
        current_storytime_site(request).pages.friendly.exists?(request.params[:id])
      end
    end
  end
end