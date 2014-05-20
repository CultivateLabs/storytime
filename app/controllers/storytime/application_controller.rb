module Storytime
  class ApplicationController < ActionController::Base
    # layout Storytime.layout

  private
    
    def ensure_site
      redirect_to new_dashboard_site_url unless @site = Site.first
    end

  end
end
