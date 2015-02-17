require_dependency "storytime/application_controller"

module Storytime
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :verify_storytime_user, unless: ->{ Storytime::Site.count == 0 }
    layout "storytime/dashboard"
    
    after_action :verify_authorized

  private

    def verify_storytime_user
      raise Pundit::NotAuthorizedError if current_user.storytime_role.nil?
    end
  
    def load_media
      @media = Media.order("created_at DESC").page(1).per(10)
      @large_gallery = false
    end

    def dashboard_controller
      true
    end

  end
end
