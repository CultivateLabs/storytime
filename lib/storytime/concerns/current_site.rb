module Storytime
  module Concerns
    module CurrentSite
      def current_site(request)
        @site = Storytime::Site.find_by(custom_domain: request.host)
      end
    end
  end
end