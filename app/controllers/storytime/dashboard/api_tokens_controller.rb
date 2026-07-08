require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class ApiTokensController < DashboardController
      respond_to :json

      before_action :load_api_tokens, only: [:index, :create]
      before_action :load_api_token, only: [:destroy]

      def index
        authorize Storytime::ApiToken
        respond_with @api_tokens
      end

      def create
        @api_token = Storytime::ApiToken.new(name: api_token_params[:name])
        @api_token.user = current_user
        @api_token.site = current_storytime_site
        @api_token.expires_at = parse_expiration(api_token_params[:expires_at])
        authorize @api_token

        respond_to do |format|
          if @api_token.save
            # Surface the raw token once so the panel can display it.
            @created_token = @api_token.raw_token
            load_api_tokens
            format.json { render :index }
          else
            format.json { render :index, status: :unprocessable_entity }
          end
        end
      end

      def destroy
        authorize @api_token
        @api_token.destroy
        respond_with @api_token
      end

    private

      def load_api_tokens
        @api_tokens = Storytime::ApiToken.order("created_at DESC")
      end

      def load_api_token
        @api_token = Storytime::ApiToken.find(params[:id])
      end

      def api_token_params
        params.require(:api_token).permit(:name, :expires_at)
      end
    end
  end
end
