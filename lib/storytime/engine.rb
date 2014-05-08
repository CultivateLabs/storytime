require 'devise'
require 'pundit'
require 'bootstrap-sass'
require "jquery-rails"
require 'kaminari'

module Storytime
  class Engine < ::Rails::Engine
    isolate_namespace Storytime
  end
end
