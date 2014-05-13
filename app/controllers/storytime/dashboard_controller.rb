require_dependency "storytime/application_controller"

module Storytime
  class DashboardController < ApplicationController
    layout "storytime/dashboard"
    include Pundit
    before_action :authenticate_user!
    after_action :verify_authorized

  private

    def load_media
      @media = Media.order("created_at DESC").page(1).per(10)
    end

  end
end
