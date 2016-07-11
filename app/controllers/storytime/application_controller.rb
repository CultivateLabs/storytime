class Storytime::ApplicationController < Storytime.application_controller_superclass
  layout :set_layout

  before_action :ensure_site_exists
  around_action :scope_current_site

  include Storytime::Concerns::ControllerContentFor
  include Storytime::Concerns::CurrentSite
  helper_method :current_storytime_site

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  helper :all

  helper_method :dashboard_controller

  if Storytime.user_class_symbol != :user && !respond_to(:current_user)
    helper_method :authenticate_user!
    helper_method :current_user
    helper_method :user_signed_in?

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

  def setup
    url = if Storytime.user_class.count == 0
      Storytime.registration_path
    elsif current_user.nil?
      Storytime.login_path
    elsif Storytime::Site.count == 0
      new_dashboard_site_url
    else
      url_for([:dashboard, Storytime::Page])
    end

    redirect_to url
  end

private

  def ensure_site_exists
    setup if Storytime::Site.count == 0
  end

  def set_layout
    @current_storytime_site.layout.present? ? @current_storytime_site.layout : "storytime/application"
  end

  def dashboard_controller
    false
  end

  def scope_current_site
    Storytime::Site.current_id = current_storytime_site(request).id
    yield
  ensure
    Storytime::Site.current_id = nil
  end

  def user_not_authorized
    flash[:error] = "You are not authorized to perform this action."
    redirect_to(request.referrer || "/")
  end
end
