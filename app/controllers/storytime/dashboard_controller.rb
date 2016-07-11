require_dependency "storytime/application_controller"

module Storytime
  class DashboardController < ::Storytime::ApplicationController
    before_action :authenticate_user!
    before_action :verify_storytime_user, unless: ->{ Storytime::Site.count == 0 }
    layout "storytime/dashboard"

    after_action :verify_authorized, unless: :admin_controller?

  private

    def verify_storytime_user
      raise Pundit::NotAuthorizedError if current_user.storytime_memberships.count == 0
    end

    def load_media
      @media = Media.order("created_at DESC").page(1).per(10)
      @large_gallery = false
    end

    def dashboard_controller
      true
    end

    def admin_controller?
      false
    end
  end
end
