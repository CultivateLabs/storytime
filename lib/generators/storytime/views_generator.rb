require 'rails/generators/base'

module Storytime
  module Generators
    module ViewPathTemplates
      extend ActiveSupport::Concern

      included do
        argument :scope, :required => false, :default => nil,
                         :desc => "The scope to copy views to"

        public_task :copy_views
      end

      module ClassMethods
        def hide!
          Rails::Generators.hide_namespace self.namespace
        end
      end

      protected

      def view_directory(name, _target_path=nil)
        directory name.to_s, _target_path || "#{target_path}/#{name}" do |content|
          content
        end
      end

      def target_path
        @target_path ||= "app/views/#{scope || :storytime}"
      end
    end

    class ViewsGenerator < Rails::Generators::Base
      include ViewPathTemplates
      source_root File.expand_path("../../../../app/views/storytime/", __FILE__)

      desc "Copies Storytime views to your application."

      argument :scope, :required => false, :default => nil,
                       :desc => "The scope to copy views to"

      def copy_views
        view_directory :application
        view_directory :blog_posts
        view_directory :comments
        view_directory :pages
        view_directory :posts
        view_directory :sites
      end
    end
  end
end