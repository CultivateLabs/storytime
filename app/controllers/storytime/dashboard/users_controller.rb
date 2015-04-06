require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class UsersController < DashboardController
      before_action :load_user, only: [:edit, :update]

      respond_to :json

      def new
        @user = Storytime.user_class.new
        @membership = @user.storytime_memberships.new
        authorize @user
        respond_with @user
      end

      def create
        membership_attrs = params[:user].delete(:storytime_memberships_attributes)["0"]
        @user = Storytime.user_class.new(user_params)
        authorize @user

        respond_to do |format|
          if @user.save
            @user.storytime_memberships.create(storytime_role_id: membership_attrs[:storytime_role_id])
            @memberships = current_storytime_site.memberships.includes(:user).page(params[:page]).per(20)
            format.json { render "storytime/dashboard/memberships/index" }
          else
            @membership = @user.storytime_memberships.new
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
            load_user
            format.json { render :index }
          else
            format.json { render :edit, status: :unprocessable_entity }
          end
        end
      end

    private
      def user_params
        params.require(Storytime.user_class_symbol).permit(:email, :storytime_name, :password, :password_confirmation, memberships_attributes: [:id, :storytime_role_id, :_destroy])
      end

      def load_user
        @user = Storytime.user_class.find(params[:id])
      end
    end
  end
end