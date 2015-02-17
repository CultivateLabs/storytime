require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class SnippetsController < DashboardController
      before_action :set_snippet, only: [:edit, :update, :destroy]
      before_action :load_snippets
      before_action :load_media, only: [:new, :edit, :update, :create]
      
      respond_to :json
      respond_to :html, only: :destroy

      def index
        authorize @snippets
        respond_with @snippets
      end

      def new
        @snippet = Storytime::Snippet.new
        authorize @snippet
        respond_with @snippet
      end

      def edit
        authorize @snippet
        respond_with @snippet
      end

      def create
        @snippet = Storytime::Snippet.new(snippet_params)
        authorize @snippet

        respond_with @snippet do |format|
          if @snippet.save
            format.json { render :index }
          else
            format.json { render :new, status: :unprocessable_entity }
          end
        end
      end

      def update
        authorize @snippet

        respond_with @snippet do |format|
          if @snippet.update(snippet_params)
            format.json { render :index }
          else
            format.json { render :edit, status: :unprocessable_entity }
          end
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
        @snippets = Storytime::Snippet.order(created_at: :desc).page(params[:page_number]).per(20)
      end

    end
  end
end
