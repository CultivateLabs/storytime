require 'devise'
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

module Storytime
  class Engine < ::Rails::Engine
    isolate_namespace Storytime
  end
end
