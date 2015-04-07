require 'rails/generators/base'

module Storytime
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a Storytime initializer for your application."

      def set_local_assigns
        @user_class = 'User'
        @dashboard_namespace_path = '/storytime'
        @post_types = ['CustomPostType']
        @post_title_character_limit = 100
        @post_excerpt_character_limit = 500
        @email_regexp = '/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/'
        @search_adapter = "''"
        @enable_file_upload = true
        @aws_region = "ENV['STORYTIME_AWS_REGION']"
        @aws_access_key_id = "ENV['STORYTIME_AWS_ACCESS_KEY_ID']"
        @aws_secret_key = "ENV['STORYTIME_AWS_SECRET_KEY']"
        @s3_bucket = 'my-s3-bucket'
        @prod_media_storage = ':s3'
        @dev_media_storage = ':file'
      end

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