require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class MediaController < DashboardController
      respond_to :json, only: [:create, :destroy]

      def index
        @media = Media.order("created_at DESC")
        authorize @media
      end

      def create
        @media = current_user.media.new(media_params)
        authorize @media
        @media.save
        respond_with :dashboard, @media do |format|
          format.json{ render :show }
        end
      end
      
      def destroy
        @media = Media.find(params[:id])
        authorize @media
        @media.destroy
        respond_with @media
      end

    private

      def media_params
        params.require(:media).permit(:file)
      end

    end
  end
end
