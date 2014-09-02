class Storytime::ApplicationController < ApplicationController
  layout Storytime.layout || "storytime/application"
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  helper :all

  def current_category
    @category ||= Storytime::Category.find_by(name: params[:category]) if params[:category].present?
  end
  helper_method :current_category

  def setup
    url = if Storytime.user_class.count == 0
      main_app.new_user_registration_url
    elsif current_user.nil?
      main_app.new_user_session_url
    elsif Storytime::Site.count == 0
      new_dashboard_site_url
    else
      dashboard_posts_url
    end

    redirect_to url
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
