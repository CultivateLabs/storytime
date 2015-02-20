module Storytime
  module Constraints
    class PageHomepageConstraint
      include Storytime::Concerns::CurrentSite
     
      def matches?(request)
        current_site(request).homepage.is_a?(Storytime::Page)
      end
    end
  end
end