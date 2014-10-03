require 'rails/generators/base'

module Storytime
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a Storytime initializer for your application."

      def copy_initializer
        template "storytime.rb", "config/initializers/storytime.rb"
      end

      def add_storytime_routes
        storytime_routes = 'mount Storytime::Engine => "/"'

        route storytime_routes
      end

      def show_readme
        readme "README" if behavior == :invoke
      end
    end
  end
end