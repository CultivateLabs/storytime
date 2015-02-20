module Storytime
  module Concerns
    module CurrentSite
      def current_site(request)
        @site = Storytime::Site.find_by!(subdomain: request.subdomain)
      end
    end
  end
end