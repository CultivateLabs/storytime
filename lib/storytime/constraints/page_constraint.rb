module Storytime
  module Constraints
    class PageConstraint
      include Storytime::Concerns::CurrentSite
      
      def matches?(request)
        site = current_storytime_site(request)
        site.pages.friendly.exists?(request.params[:id]) ||
        File.exists?(Rails.root.join('app', 'views', "storytime/#{site.custom_view_path}/pages/#{ActionController::Base.helpers.sanitize(request.params[:id])}.html.erb"))
      end
    end
  end
end