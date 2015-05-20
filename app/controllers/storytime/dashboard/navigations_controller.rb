require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class NavigationsController < DashboardController
      def index
        authorize current_storytime_site, :manage?
        @navigations = Navigation.all
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

    private
      def navigation_params
        params.require(:navigation).permit(:name, :handle)
      end
    end
  end
end
