require 'devise'
require 'pundit'
require 'bootstrap-sass'
require 'jquery-rails'
require 'kaminari'
require 'simple_form'
require 'friendly_id'
require 'fog/aws/storage'
require 'carrierwave'

module Storytime
  class Engine < ::Rails::Engine
    isolate_namespace Storytime
  end
end
