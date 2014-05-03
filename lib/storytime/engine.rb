require 'devise'
require 'bootstrap-sass'
require 'pundit'
require 'kaminari'

module Storytime
  class Engine < ::Rails::Engine
    isolate_namespace Storytime
  end
end
