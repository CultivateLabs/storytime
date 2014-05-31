require 'pundit'
require 'bootstrap-sass'
require 'jquery-rails'
require 'jbuilder'
require 'kaminari'
require 'simple_form'
require 'friendly_id'
require 'fog/aws/storage'
require 'carrierwave'

require 'storytime/concerns/has_versions'
require 'storytime/concerns/storytime_user'
require 'storytime/constraints/root_constraint'
require 'storytime/controller_helpers'

module Storytime
  class Engine < ::Rails::Engine
    isolate_namespace Storytime

    initializer "storytime.controller_helpers" do
      ActiveSupport.on_load(:action_controller) do
        include Storytime::ControllerHelpers
      end
    end
  end
end
