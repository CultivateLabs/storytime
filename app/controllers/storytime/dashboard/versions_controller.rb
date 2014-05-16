require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class VersionsController < DashboardController
      def revert
        @version = Storytime::Version.find(params[:id])
        authorize @version

        if @version.versionable.update_columns(content: @version.content)
          @version.touch
          redirect_to polymorphic_url([:dashboard, @version.versionable], action: :edit)
        end
      end
    end
  end
end