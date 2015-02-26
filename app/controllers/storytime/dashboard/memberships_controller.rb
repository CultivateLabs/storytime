module Storytime
  module Dashboard
    class MembershipsController < DashboardController
      respond_to :json
      
      def create
        @membership = Membership.new(membership_params)
        authorize @membership

        respond_with @membership do |format|
          if @membership.save
            @users = @site.users.page(params[:page]).per(20)
            format.json { render :save }
          else
            @users = @site.users.page(params[:page]).per(20)
            format.json { render :save, status: :unprocessable_entity }
          end
        end
      end

    private
      def membership_params
        permitted_attrs = policy(@membership || Storytime::Membership.new).permitted_attributes
        params.require(:membership).permit(*permitted_attrs)
      end
    end
  end
end