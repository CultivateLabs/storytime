module Storytime
  module Constraints
    class PageConstraint
      include Storytime::Concerns::CurrentSite

      def matches?(request)
        id = request.params[:id].to_s
        # Reject path traversal: params[:id] comes from the "/*id" glob route, so it
        # can contain "/" and ".." segments. sanitize() only strips HTML, not "../",
        # which would let the File.exist? below probe arbitrary filesystem paths
        return false if id.include?("..")

        site = current_storytime_site(request)
        site.pages.friendly.exists?(id) ||
        File.exist?(Rails.root.join('app', 'views', "storytime/#{site.custom_view_path}/pages/#{ActionController::Base.helpers.sanitize(id)}.html.erb"))
      end
    end
  end
end
