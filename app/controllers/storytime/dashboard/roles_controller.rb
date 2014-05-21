require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class RolesController < DashboardController
      def update_multiple
        authorize @site, :update?
        @roles = Storytime::Role.update(params[:roles].keys, params[:roles].values)
        redirect_to storytime.edit_dashboard_site_path(@site), notice: I18n.t("flash.roles.update.success")
      end
    end
  end
end