module Storytime
  module ControllerHelpers
    def storytime_controller?
      is_a?(Storytime::ApplicationController)
    end
  end
end