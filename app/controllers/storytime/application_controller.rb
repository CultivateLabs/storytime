module Storytime
  class ApplicationController < ActionController::Base
    # layout Storytime.layout
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private
    def ensure_site
      redirect_to new_dashboard_site_url unless @site = Site.first
    end
    
    def user_not_authorized
      flash[:error] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end
  end
end
