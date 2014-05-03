require 'devise'
require 'bootstrap-sass'
require 'pundit'

module Storytime
  class Engine < ::Rails::Engine
    isolate_namespace Storytime
  end
end
