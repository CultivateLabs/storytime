require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class SitesController < DashboardController
      skip_before_action :ensure_site_exists, only: [:new, :create]
      skip_around_action :scope_current_site, only: [:new, :create]
      around_action :scope_current_site, unless: :skip_scope_current_site?

      before_action :set_site, only: [:edit, :update, :destroy]
      respond_to :json, only: [:edit, :update]

      def new
        @site = Site.new
        authorize @site
      end

      def edit
        authorize @site
        render :site
      end

      def create
        @site = Site.new(site_params)
        authorize @site

        if @site.save_with_seeds(current_user)
          redirect_to storytime.dashboard_url(host: @site.custom_domain), notice: I18n.t('flash.sites.create.success')
        else
          render :new
        end
      end

      def update
        authorize @site
        if @site.update(site_params)
          render :site
        else
          render :site, status: 422
        end
      end

      def destroy
        authorize @site
        @site.destroy
        redirect_to storytime.dashboard_url(host: Storytime::Site.first.custom_domain), notice: t('flash.sites.destroy.success')
      end

    private
      def skip_scope_current_site?
        %w[new create].include?(params[:action]) && Storytime::Site.count == 0
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_site
        @site = Site.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def site_params
        params.require(:site).permit(:title, :post_slug_style, :ga_tracking_id, :root_post_id, :custom_domain, :subscription_email_from, :layout, :disqus_forum_shortname, :discourse_name)
      end

    end
  end
end
