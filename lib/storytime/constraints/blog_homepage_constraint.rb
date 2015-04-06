module Storytime
  module Constraints
    class BlogHomepageConstraint
      include Storytime::Concerns::CurrentSite
      def matches?(request)
        site = current_storytime_site(request)
        site.present? && site.homepage.present? && site.homepage.is_a?(Storytime::Blog)
      end
    end
  end
end