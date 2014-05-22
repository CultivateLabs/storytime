require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class PagesController < DashboardController
      before_action :set_page, only: [:edit, :update, :destroy]
      before_action :load_pages
      before_action :load_media, only: [:new, :edit]
      
      respond_to :json, only: :destroy
      respond_to :html, only: :destroy

      def index
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
          redirect_to edit_dashboard_page_url(@page), notice: I18n.t('flash.pages.create.success')
        else
          load_media
          render :new
        end
      end

      def update
        authorize @page
        @page.draft_user_id = current_user.id
        if @page.update(page_params)
          redirect_to edit_dashboard_page_url(@page), notice: I18n.t('flash.pages.update.success')
        else
          load_media
          render :edit
        end
      end

      def destroy
        authorize @page
        @page.destroy
        flash[:notice] = I18n.t('flash.pages.destroy.success') unless request.xhr?
        respond_with [:dashboard, @page]
      end

      private
        def set_page
          @page = Page.friendly.find(params[:id])
        end

        def load_pages
          # Patch for conflict between our form params and pagination
          pg = params[:page].respond_to?(:to_i) ? params[:page] : 1
          @pages = policy_scope(Storytime::Page).page(pg).per(10)
        end

        def page_params
          params.require(:page).permit(*policy(@page || current_user.pages.new).permitted_attributes)
        end
    end
  end
end
