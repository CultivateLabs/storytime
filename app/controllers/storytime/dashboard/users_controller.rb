require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class UsersController < DashboardController
      before_action :expire_cache
      before_action :load_user, only: [:edit, :update, :destroy]

      respond_to :json

      def index
        @users = Storytime.user_class.page(params[:page]).per(20)
        authorize @users
        render :index, status: 200
      end

      def new
        @user = Storytime.user_class.new
        authorize @user
        render :new, status: 200
      end

      def create
        @user = Storytime.user_class.new(user_params)
        authorize @user

        if @user.save
          render :new
        else
          render :new, status: 422
        end
      end

      def edit
        authorize @user
        render :edit, status: 200
      end

      def update
        authorize @user

        if @user.update(user_params)
          render :edit
        else
          render :edit, status: 422
        end
      end

      def destroy
        authorize @user
        @user.destroy
        respond_with @user
      end

    private
      def expire_cache
        expires_now
      end

      def user_params
        params.require(Storytime.user_class_symbol).permit(:email, :storytime_role_id, :storytime_name, :password, :password_confirmation)
      end

      def load_user
        @user = Storytime.user_class.find(params[:id])
      end
    end
  end
end