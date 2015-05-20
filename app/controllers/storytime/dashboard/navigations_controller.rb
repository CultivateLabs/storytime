require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class NavigationsController < DashboardController
      def index
        authorize current_storytime_site, :manage?
        @navigations = Navigation.all
      end
    end
  end
end
