require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class RolesController < DashboardController
      before_action :load_roles
      respond_to :json

      def edit_multiple
        authorize @current_storytime_site, :update?
        render :edit
      end

      def update_multiple
        authorize @current_storytime_site, :update?
        @roles = Storytime::Role.update(params[:roles].keys, params[:roles].values)
        render :edit
      end

    private
      def load_roles
        @roles = Storytime::Role.all
        @actions = Storytime::Action.all
      end
    end
  end
end