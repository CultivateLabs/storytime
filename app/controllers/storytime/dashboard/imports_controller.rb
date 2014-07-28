require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class ImportsController < DashboardController
      respond_to :json, only: [:create]

      def new
        authorize Importers::Importer
      end

      def create
        authorize Importers::Importer
        importer = Importers::Wordpress.new(params[:import][:file], current_user)
        importer.import!
        render :show
      end

    private

      def import_params
        params.require(:import).permit(:file)
      end

    end
  end
end
