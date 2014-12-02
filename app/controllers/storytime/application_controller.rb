class Storytime::ApplicationController < ApplicationController
  layout Storytime.layout || "storytime/application"

  include Storytime::Concerns::ControllerContentFor
  
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  helper :all

  helper_method :current_user if Storytime.user_class_symbol != :user

  def setup
    url = if Storytime.user_class.count == 0
      main_app.new_user_registration_url
    elsif current_user.nil?
      main_app.new_user_session_url
    elsif Storytime::Site.count == 0
      new_dashboard_site_url
    else
      url_for([:dashboard, Storytime::BlogPost])
    end

    redirect_to url
  end

  if Storytime.user_class_symbol != :user
    def current_user
      send("current_#{Storytime.user_class.to_s.downcase}".to_sym)
    end
  end

private
  def ensure_site
    redirect_to new_dashboard_site_url unless devise_controller? || @site = Storytime::Site.first
  end
  
  def user_not_authorized
    flash[:error] = "You are not authorized to perform this action."
    redirect_to(request.referrer || storytime_root_path)
  end
end
