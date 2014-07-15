require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class PostTypesController < DashboardController
      before_action :set_post_type, only: [:edit, :update, :destroy]
      before_action :load_post_types
      
      respond_to :json, only: :destroy
      respond_to :html, only: :destroy

      def index
        authorize @post_types
      end

      def new
        @post_type = PostType.new
        authorize @post_type
      end

      def edit
        authorize @post_type
      end

      def create
        @post_type = PostType.new(post_type_params)
        authorize @post_type

        if @post_type.save
          redirect_to edit_dashboard_post_type_url(@post_type), notice: I18n.t('flash.post_types.create.success')
        else
          render :new
        end
      end

      def update
        authorize @post_type
        if @post_type.update(post_type_params)
          redirect_to edit_dashboard_post_type_url(@post_type), notice: I18n.t('flash.post_types.update.success')
        else
          render :edit
        end
      end

      def destroy
        authorize @post_type
        @post_type.destroy
        flash[:notice] = I18n.t('flash.post_types.destroy.success') unless request.xhr?
        respond_with [:dashboard, @post_type]
      end

    private

      def load_post_types
        @post_types = PostType.all.page(params[:page]).per(10)
      end

      def set_post_type
        @post_type = PostType.find(params[:id])
      end

      def post_type_params
        params.require(:post_type).permit(*policy(@post_type || PostType.new).permitted_attributes)
      end

    end
  end
end
