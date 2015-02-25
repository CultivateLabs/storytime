class Storytime::ApplicationController < ApplicationController
  layout :set_layout

  around_filter :scope_current_site

  include Storytime::Concerns::ControllerContentFor
  include Storytime::Concerns::CurrentSite
  helper_method :current_site
  
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  helper :all

  helper_method :dashboard_controller

  if Storytime.user_class_symbol != :user
    helper_method :authenticate_user!
    helper_method :current_user
    helper_method :user_signed_in?
  end

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
    def authenticate_user!
      send("authenticate_#{Storytime.user_class_underscore_all}!".to_sym)
    end

    def current_user
      send("current_#{Storytime.user_class_underscore_all}".to_sym)
    end

    def user_signed_in?
      send("#{Storytime.user_class_underscore_all}_signed_in?".to_sym)
    end
  end

private
  def set_layout
    @site.layout.present? ? @site.layout : "storytime/application"
  end

  def dashboard_controller
    false
  end

  def scope_current_site
    begin
      Storytime::Site.current_id = current_site(request).id
      yield
    rescue
      redirect_to storytime.new_dashboard_site_path
    end
  ensure
    Storytime::Site.current_id = nil
  end
  
  def user_not_authorized
    flash[:error] = "You are not authorized to perform this action."
    redirect_to(request.referrer || storytime_root_path)
  end
end
