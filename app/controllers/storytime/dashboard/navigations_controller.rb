require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class NavigationsController < DashboardController
      respond_to :json, only: :destroy

      def index
        authorize current_storytime_site, :manage?
        @navigations = Navigation.includes(:links)
      end

      def new
        authorize current_storytime_site, :manage?
        @navigation = Navigation.new
      end

      def create
        authorize current_storytime_site, :manage?
        @navigation = Navigation.new(navigation_params)

        respond_to do |format|
          if @navigation.save
            format.html { redirect_to [storytime, :edit, :dashboard, @navigation], notice: t('dashboard.navigations.create.success') }
          else
            format.html { render :new }
          end
        end
      end

      def edit
        authorize current_storytime_site, :manage?
        @navigation = Navigation.find(params[:id])
      end

      def update
        authorize current_storytime_site, :manage?
        @navigation = Navigation.find(params[:id])

        respond_to do |format|
          if @navigation.update(navigation_params)
            format.html { redirect_to [storytime, :edit, :dashboard, @navigation], notice: t('dashboard.navigations.update.success') }
          else
            format.html { render :edit }
          end
        end
      end

      def destroy
        authorize current_storytime_site, :manage?
        @navigation = Navigation.find(params[:id])
        @navigation.destroy
        flash[:notice] = I18n.t('flash.navigations.destroy.success') unless request.xhr?
        
        respond_with [:dashboard, @navigation] do |format|
          format.html{ redirect_to url_for([:dashboard, Storytime::Navigation]) }
        end
      end

    private
      def navigation_params
        params.require(:navigation).permit(:name, :handle, links_attributes: [:id, :text, :url, :linkable_type, :linkable_id, :_destroy])
      end
    end
  end
end
