module Storytime
  module Constraints
    class BlogHomepageConstraint
      include Storytime::Concerns::CurrentSite
      
      def matches?(request)
        current_site(request).homepage.present? && current_site(request).homepage.is_a?(Storytime::Blog)
      end
    end
  end
end