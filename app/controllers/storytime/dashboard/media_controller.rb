require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class MediaController < DashboardController

      def index
        @media = Media.all
        authorize @media
      end

      def new
        @media = current_user.media.new
        authorize @media
      end

      def create
        @media = current_user.media.new(media_params)
        authorize @media

        if @media.save
          redirect_to dashboard_media_index_url, notice: 'Media was successfully created.'
        else
          render :new
        end
      end
      
      def destroy
        @media = Media.find(params[:id])
        authorize @media
        @media.destroy
        redirect_to dashboard_media_index_url, notice: 'Media was successfully destroyed.'
      end

    private

      def media_params
        params.require(:media).permit(:file)
      end

    end
  end
end
