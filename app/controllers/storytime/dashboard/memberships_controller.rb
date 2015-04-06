module Storytime
  module Dashboard
    class MembershipsController < DashboardController
      before_action :load_memberships, only: :index
      before_action :load_membership, only: [:destroy]
      respond_to :json

      def index
        authorize @memberships
        respond_with @memberships
      end
      
      def create
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

      def destroy
        authorize @membership
        @membership.destroy
        respond_with @membership
      end

    private

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