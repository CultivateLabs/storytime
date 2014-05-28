module Storytime
  class ApplicationController < ActionController::Base
    layout Storytime.layout || "storytime/application"
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    def after_sign_up_path_for(user)
      if Storytime::User.count == 1
        new_dashboard_site_url
      else
        dashboard_posts_url
      end
    end

    def setup
      url = if User.count == 0
        new_user_registration_url
      elsif Site.count == 0
        new_dashboard_site_url
      else
        dashboard_posts_url
      end

      redirect_to url
    end

  private
    def ensure_site
      redirect_to new_dashboard_site_url unless devise_controller? || @site = Site.first
    end
    
    def user_not_authorized
      flash[:error] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end
  end
end
