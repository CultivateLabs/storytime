require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class CategoriesController < DashboardController
      before_action :set_category, only: [:edit, :update, :destroy]
      before_action :load_categories
      
      respond_to :json, only: :destroy
      respond_to :html, only: :destroy

      def index
        authorize @categories
      end

      def new
        @category = Category.new
        authorize @category
      end

      def edit
        authorize @category
      end

      def create
        @category = Category.new(category_params)
        authorize @category

        if @category.save
          redirect_to url_for([:edit, :dashboard, @category]), notice: I18n.t('flash.categories.create.success')
        else
          render :new
        end
      end

      def update
        authorize @category
        if @category.update(category_params)
          redirect_to url_for([:edit, :dashboard, @category]), notice: I18n.t('flash.categories.update.success')
        else
          render :edit
        end
      end

      def destroy
        authorize @category
        @category.destroy
        flash[:notice] = I18n.t('flash.categories.destroy.success') unless request.xhr?
        respond_with [:dashboard, @category]
      end

    private

      def load_categories
        @categories = Category.all.page(params[:page]).per(10)
      end

      def set_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(*policy(@category || Category.new).permitted_attributes)
      end

    end
  end
end
