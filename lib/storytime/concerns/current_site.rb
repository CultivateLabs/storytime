module Storytime
  module Concerns
    module CurrentSite
      def current_site(req = nil)
        req ||= request if respond_to?(:request)
        @site = Storytime::Site.find_by(custom_domain: req.host) || Storytime::Site.first
      end
    end
  end
end