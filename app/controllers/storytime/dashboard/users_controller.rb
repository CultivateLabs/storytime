require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class UsersController < DashboardController
      before_action :load_users, only: :index
      before_action :load_user, only: [:edit, :update, :destroy]

      respond_to :json

      def index
        authorize @users
        respond_with @users
      end

      def new
        @user = Storytime.user_class.new
        authorize @user
        respond_with @user
      end

      def create
        @user = Storytime.user_class.new(user_params)
        authorize @user

        respond_with @user do |format|
          if @user.save
            load_users
            format.json { render :index }
          else
            format.json { render :new, status: :unprocessable_entity }
          end
        end
      end

      def edit
        authorize @user
        respond_with @user
      end

      def update
        authorize @user

        respond_with @user do |format|
          if @user.update(user_params)
            load_users
            format.json { render :index }
          else
            format.json { render :edit, status: :unprocessable_entity }
          end
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

      def load_users
        @users = Storytime.user_class.page(params[:page]).per(20)
      end

      def load_user
        @user = Storytime.user_class.find(params[:id])
      end
    end
  end
end