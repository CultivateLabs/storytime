require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class RolesController < DashboardController
      respond_to :json

      def edit_multiple
        authorize @site, :update?
        render :edit
      end

      def update_multiple
        authorize @site, :update?
        @roles = Storytime::Role.update(params[:roles].keys, params[:roles].values)
        render :edit
      end
    end
  end
end