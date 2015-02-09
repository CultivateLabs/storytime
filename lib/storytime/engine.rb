require 'pundit'
require 'bootstrap-sass'
require 'jquery-rails'
require 'jquery-ui-rails'
require 'jbuilder'
require 'kaminari'
require 'simple_form'
require 'friendly_id'
require 'fog/aws/storage'
require 'carrierwave'
require 'nokogiri'
require 'font-awesome-sass'
require 'leather'
require 'codemirror-rails'

require 'storytime/concerns/has_versions'
require 'storytime/concerns/storytime_user'
require 'storytime/concerns/controller_content_for'
require 'storytime/controller_helpers'

require 'storytime/importers/importer'
require 'storytime/importers/wordpress'

module Storytime
  class Engine < ::Rails::Engine
    isolate_namespace Storytime

    initializer "storytime.controller_helpers" do
      ActiveSupport.on_load(:action_controller) do
        include Storytime::ControllerHelpers
        
        helper Storytime::SubscriptionsHelper
      end
    end

    # putting this here rather than config/initializers so that Storytime is configured before getting here
    initializer "storytime.configure_carrierwave" do
      CarrierWave.configure do |config|
        if Storytime.media_storage == :s3
          config.storage = :fog
          config.fog_credentials = {
            :provider               => 'AWS',
            :aws_access_key_id      => ENV['STORYTIME_AWS_ACCESS_KEY_ID'],
            :aws_secret_access_key  => ENV['STORYTIME_AWS_SECRET_KEY']
          }
          config.fog_directory  = Storytime.s3_bucket
          config.fog_public     = true
          config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
        else
          config.storage = :file
        end
        
        config.enable_processing = !Rails.env.test?
      end
    end

    initializer "storytime.register_default_post_types" do
      Storytime.configure do |config|
        config.post_types += ["Storytime::BlogPost", "Storytime::Page"]
      end
    end
  end
end
