require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class SubscriptionsController < DashboardController
      before_action :load_subscriptions, only: [:index]
      before_action :set_subscription, only: [:edit, :update, :destroy]

      respond_to :json, only: :destroy

      def index
        authorize @subscriptions
      end

      def new
        @subscription = Storytime::Subscription.new
        authorize @subscription
      end

      def create
        @subscription = Storytime::Subscription.new(subscription_params)
        authorize @subscription

        if @subscription.save
          redirect_to dashboard_subscriptions_path, notice: I18n.t('flash.subscriptions.create.success')
        else
          render :new
        end
      end

      def edit
        authorize @subscription
      end

      def update
        authorize @subscription

        if @subscription.update(subscription_params)
          redirect_to dashboard_subscriptions_path, notice: I18n.t('flash.subscriptions.update.success')
        else
          render :edit
        end
      end

      def destroy
        authorize @subscription
        @subscription.destroy
        respond_with @subscription
      end

    private

      def subscription_params
        params.require(:subscription).permit(:email, :subscribed)
      end

      def set_subscription
        @subscription = Storytime::Subscription.find(params[:id])
      end

      def load_subscriptions
        @subscriptions = Storytime::Subscription.order(created_at: :desc).page(params[:page_number]).per(10)
      end
    end
  end
end
