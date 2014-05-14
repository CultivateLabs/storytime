require_dependency "storytime/application_controller"

module Storytime
  class DashboardController < ApplicationController
    layout "storytime/dashboard"
    include Pundit
    before_action :authenticate_user!
    before_action :ensure_site, unless: ->{ params[:controller] == "storytime/dashboard/sites" }
    after_action :verify_authorized

  private

    def ensure_site
      redirect_to new_dashboard_site_url unless @site = Site.first
    end

    def load_media
      @media = Media.order("created_at DESC").page(1).per(10)
    end

  end
end
