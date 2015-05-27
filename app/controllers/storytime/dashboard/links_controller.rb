require_dependency "storytime/dashboard/posts_controller"

module Storytime
  module Dashboard
    class LinksController < DashboardController
      def sort
        authorize current_storytime_site, :manage?
        @navigation = Navigation.find(params[:navigation_id])
        params[:link].each_with_index do |id, index|
          @navigation.links.where(id: id).update_all({position: index+1})
        end
        render nothing: true
      end
    end
  end
end