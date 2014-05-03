require_dependency "storytime/application_controller"

module Storytime
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    after_action :verify_authorized
  end
end
