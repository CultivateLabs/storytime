require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class UsersController < DashboardController
      before_action :load_user, only: [:edit, :update, :destroy]

      respond_to :json, only: :destroy

      def index
        @users = Storytime.user_class.page(params[:page]).per(20)
        authorize @users
      end

      def new
        @user = Storytime.user_class.new
        authorize @user
      end

      def create
        @user = Storytime.user_class.new(user_params)
        authorize @user

        if @user.save
          redirect_to dashboard_users_path, notice: I18n.t('flash.users.create.success')
        else
          render :new
        end
      end

      def edit
        authorize @user
      end

      def update
        authorize @user
        if @user.update(user_params)
          redirect_to dashboard_users_path, notice: I18n.t('flash.users.update.success')
        else
          render :edit
        end
      end

      def destroy
        authorize @user
        @user.destroy
        respond_with @user
      end

    private
      def user_params
        params.require(Storytime.user_class_symbol).permit(:email, :storytime_role_id, :storytime_name, :password, :password_confirmation)
      end

      def load_user
        @user = Storytime.user_class.find(params[:id])
      end
    end
  end
end