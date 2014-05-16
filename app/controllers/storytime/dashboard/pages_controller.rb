require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class PagesController < DashboardController
      before_action :set_page, only: [:edit, :update, :destroy]
      before_action :load_media, only: [:new, :edit]
      
      respond_to :json, only: [:destroy]

      def index
        @pages = Page.all.page(params[:page]).per(10)
        authorize @pages
      end

      def new
        @page = current_user.pages.new
        authorize @page
      end

      def edit
        authorize @page
      end

      def create
        @page = current_user.pages.new(page_params)
        @page.draft_user_id = current_user.id
        authorize @page

        if @page.save
          redirect_to dashboard_pages_url, notice: I18n.t('flash.pages.create.success')
        else
          render :new
        end
      end

      def update
        authorize @page
        @page.draft_user_id = current_user.id
        if @page.update(page_params)
          redirect_to @page, notice: I18n.t('flash.pages.update.success')
        else
          render :edit
        end
      end

      def destroy
        authorize @page
        @page.destroy
        respond_with @page
      end

      private
        def set_page
          @page = Page.friendly.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def page_params
          params.require(:page).permit(:title, :draft_content, :published)
        end
    end
  end
end
