require 'active_record'
require 'bootstrap-sass'
require 'fog/aws'
require 'carrierwave'
require 'font-awesome-sass'
require 'friendly_id'
require 'jbuilder'
require 'jquery-rails'
require 'jquery-ui-rails'
require 'kaminari'
require 'leather'
require 'nokogiri'
require 'pundit'
require 'simple_form'
require 'codemirror-rails'
require 'storytime_admin'
require 'cocoon'
require 'acts_as_list'

require 'storytime/concerns/has_versions'
require 'storytime/concerns/storytime_user'
require 'storytime/concerns/controller_content_for'
require 'storytime/concerns/current_site'
require 'storytime/constraints/blog_homepage_constraint'
require 'storytime/constraints/page_homepage_constraint'
require 'storytime/constraints/blog_constraint'
require 'storytime/constraints/page_constraint'
require 'storytime/controller_helpers'
require 'storytime/post_url_handler'
require 'storytime/importers/importer'
require 'storytime/importers/wordpress'
require 'storytime/migrators/v1'

module Storytime
  class Engine < ::Rails::Engine
    isolate_namespace Storytime

    config.assets.precompile += %w( storytime/storytime-logo-nav.png )

    initializer "storytime.view_helpers" do
      ActiveSupport.on_load(:action_view) do
        include Storytime::ApplicationHelper
        include Storytime::StorytimeHelpers
      end
    end

    initializer "storytime.controller_helpers" do
      ActiveSupport.on_load(:action_controller) do
        include Storytime::ControllerHelpers
        include Storytime::Concerns::CurrentSite
        helper_method :current_storytime_site

        helper Storytime::SubscriptionsHelper
      end
    end

    # Register all decorators from app/decorators/
    initializer "storytime.decorators" do
      config.to_prepare do
        Dir.glob(Rails.root + "app/decorators/**/*_decorator*.rb").each do |c|
          require_dependency(c)
        end
      end
    end

    # putting this here rather than config/initializers so that Storytime is configured before getting there
    initializer "storytime.configure_carrierwave" do
      CarrierWave.configure do |config|
        if Storytime.media_storage == :s3
          config.fog_provider = 'fog/aws'
          config.fog_credentials = {
            provider:              'AWS',
            aws_access_key_id:     Storytime.aws_access_key_id,
            aws_secret_access_key: Storytime.aws_secret_key,
            region:                Storytime.aws_region
          }
          config.fog_directory  = Storytime.s3_bucket
          config.fog_public     = true
          config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
          config.storage = :fog
        else
          config.storage = :file
        end

        config.enable_processing = !Rails.env.test?
      end
    end

    initializer "storytime.register_default_post_types" do
      Storytime.configure do |config|
        config.post_types += ["Storytime::BlogPost", "Storytime::Page", "Storytime::Blog"]
      end
    end
  end
end
