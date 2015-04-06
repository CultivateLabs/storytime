module Storytime
  module Constraints
    class PageHomepageConstraint
      include Storytime::Concerns::CurrentSite
      def matches?(request)
        site = current_storytime_site(request)
        site.present? && site.homepage.present? && site.homepage.is_a?(Storytime::Page)
      end
    end
  end
end