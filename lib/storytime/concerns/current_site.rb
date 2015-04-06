module Storytime
  module Concerns
    module CurrentSite
      def current_storytime_site(req = nil)
        req ||= request if respond_to?(:request)
        @current_storytime_site = Storytime::Site.find_by(custom_domain: req.host) || Storytime::Site.first
      end
    end
  end
end