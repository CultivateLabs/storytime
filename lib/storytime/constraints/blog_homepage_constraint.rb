module Storytime
  module Constraints
    class BlogHomepageConstraint
      def matches?(request)
        site = Storytime::Site.find_by(subdomain: request.subdomain)
        site.present? && site.homepage.present? && site.homepage.is_a?(Storytime::Blog)
      end
    end
  end
end