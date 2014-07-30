require 'pundit'
require 'bootstrap-sass'
require 'jquery-rails'
require 'jbuilder'
require 'kaminari'
require 'simple_form'
require 'friendly_id'
require 'fog/aws/storage'
require 'carrierwave'
require 'nokogiri'

require 'storytime/concerns/has_versions'
require 'storytime/concerns/storytime_user'
require 'storytime/controller_helpers'

require 'storytime/importers/importer'
require 'storytime/importers/wordpress'

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
