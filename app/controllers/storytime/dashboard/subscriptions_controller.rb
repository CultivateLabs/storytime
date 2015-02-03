require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class SubscriptionsController < DashboardController
      skip_before_action :authenticate_user!, only: [:unsubscribe]
      skip_before_action :verify_storytime_user, only: [:unsubscribe]
      
      before_action :load_subscriptions, only: [:index]
      before_action :set_subscription, only: [:edit, :update, :destroy]

      skip_after_action :verify_authorized, only: [:unsubscribe]

      respond_to :json, only: [:index, :new, :create, :edit, :update, :destroy]

      def index
        authorize @subscriptions
      end

      def new
        @subscription = Storytime::Subscription.new
        authorize @subscription
        render :form
      end

      def create
        @subscription = Storytime::Subscription.new(subscription_params)
        authorize @subscription

        if @subscription.save
          load_subscriptions
          render :index
        else
          render :form, status: 422
        end
      end

      def edit
        authorize @subscription
        render :form
      end

      def update
        authorize @subscription

        if @subscription.update(subscription_params)
          load_subscriptions
          render :index
        else
          render :form, status: 422
        end
      end

      def destroy
        authorize @subscription
        @subscription.destroy
        respond_with @subscription
      end

      def unsubscribe
        @subscription = Storytime::Subscription.find_by(token: params[:t])

        if @subscription.nil?
          redirect_to main_app.storytime_path, alert: I18n.t('flash.subscriptions.unsubscribe.not_found')
        else
          @subscription.update_attributes(subscribed: false)
        end
      end

    private

      def subscription_params
        subscription = @subscription || Storytime::Subscription.new
        permitted_attrs = policy(subscription).permitted_attributes
        params.require(:subscription).permit(*permitted_attrs)
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
