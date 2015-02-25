module Storytime
  module Constraints
    class PageHomepageConstraint
      def matches?(request)
        site = Storytime::Site.find_by(subdomain: request.subdomain)
        site.present? && site.homepage.present? && site.homepage.is_a?(Storytime::Page)
      end
    end
  end
end