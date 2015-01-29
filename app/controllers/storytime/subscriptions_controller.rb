require_dependency "storytime/application_controller"

module Storytime
  class SubscriptionsController < ApplicationController
    before_action :set_subscription, only: [:destroy]

    def create
      @subscription = Storytime::Subscription.new(permitted_attributes)
    
      if @subscription.save
        flash[:success] = "Subscription created"
      else
        flash[:alert] = "Unable to create a subscription"
      end

      redirect_to :back
    end

    def destroy
      if permitted_attributes[:token] == @subscription.token
        flash[:success] = "Successfully unsubscribed" if @subscription.destroy
      else
        flash[:alert] = "Unable to unsubscribe"
      end

      render :back
    end

    private

      def permitted_attributes
        params.require(:subscription).permit(:email, :token)
      end

      def set_subscription
        @subscription = Storytime::Subscription.find_by(email: params[:email])
      end
  end
end
