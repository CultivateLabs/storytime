require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class SnippetsController < DashboardController
      before_action :set_snippet, only: [:edit, :update, :destroy]
      before_action :load_snippets
      before_action :load_media, only: [:new, :edit]
      
      respond_to :json, only: :destroy
      respond_to :html, only: :destroy

      def index
        authorize @snippets
      end

      def new
        @snippet = Storytime::Snippet.new
        authorize @snippet
      end

      def edit
        authorize @snippet
      end

      def create
        @snippet = Storytime::Snippet.new(snippet_params)
        authorize @snippet

        if @snippet.save
          redirect_to url_for([:edit, :dashboard, @snippet]), notice: I18n.t('flash.snippets.create.success')
        else
          load_media
          render :new
        end
      end

      def update
        authorize @snippet
        
        if @snippet.update(snippet_params)
          redirect_to url_for([:edit, :dashboard, @snippet]), notice: I18n.t('flash.snippets.update.success')
        else
          load_media
          render :edit
        end
      end

      def destroy
        authorize @snippet
        @snippet.destroy
        flash[:notice] = I18n.t('flash.snippets.destroy.success') unless request.xhr?
        
        respond_with [:dashboard, @snippet] do |format|
          format.html{ redirect_to url_for([:dashboard, Storytime::Snippet]) }
        end
      end

    private

      def set_snippet
        @snippet = Storytime::Snippet.find(params[:id])
      end

      def snippet_params
        permitted_attrs = policy(@snippet || Storytime::Snippet.new).permitted_attributes
        params.require(:snippet).permit(*permitted_attrs)
      end

      def load_snippets
        @snippets = Storytime::Snippet.order(created_at: :desc).page(params[:page_number]).per(10)
      end

    end
  end
end
