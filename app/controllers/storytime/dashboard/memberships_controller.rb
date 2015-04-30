module Storytime
  module Dashboard
    class MembershipsController < DashboardController
      before_action :load_memberships, only: :index
      before_action :load_membership, only: [:edit, :update, :destroy]

      respond_to :json

      def index
        authorize @memberships
        respond_with @memberships
      end

      def new
        @user = Storytime.user_class.new
        @membership = @user.storytime_memberships.new
        authorize @membership
        respond_with @membership
      end
      
      def create
        if params[:user]
          membership_attrs = params[:user].delete(:storytime_memberships_attributes)["0"]
          @user = Storytime.user_class.new(user_params)
          authorize @user

          respond_to do |format|
            if @user.save
              @user.storytime_memberships.create(storytime_role_id: membership_attrs[:storytime_role_id])
              
              load_memberships
              format.json { render :save }
            else
              @membership = @user.storytime_memberships.new
              format.json { render :new, status: :unprocessable_entity }
            end
          end
        else
          @membership = Membership.new(membership_params)
          authorize @membership

          respond_with @membership do |format|
            load_memberships
            if @membership.save
              format.json { render :save }
            else
              format.json { render :save, status: :unprocessable_entity }
            end
          end
        end
      end

      def edit
        authorize @membership
        respond_with @membership
      end

      def update
        authorize @membership

        respond_with @membership do |format|
          membership_user_params = membership_params
          membership_user_params['user_attributes']['id'] = @membership.user.id

          if @membership.update_attributes(membership_user_params)
            load_memberships
            format.json { render :index }
          else
            format.json { render :edit, status: :unprocessable_entity }
          end
        end
      end

      def destroy
        authorize @membership
        @membership.destroy
        respond_with @membership
      end

    private
      def user_params
        params.require(Storytime.user_class_symbol).permit(:email, :storytime_name, :password, :password_confirmation, storytime_memberships_attributes: [:storytime_role_id])
      end

      def membership_params
        permitted_attrs = policy(@membership || Storytime::Membership.new).permitted_attributes
        params.require(:membership).permit(*permitted_attrs)
      end

      def load_membership
        @membership = Storytime::Membership.find(params[:id])
      end

      def load_memberships
        @memberships = current_storytime_site.memberships.includes(:user).page(params[:page]).per(20)
      end
    end
  end
end