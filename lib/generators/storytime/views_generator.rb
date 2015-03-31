require 'rails/generators/base'

module Storytime
  module Generators
    module ViewPathTemplates
      extend ActiveSupport::Concern

      included do
        argument :scope, :required => false, :default => nil,
                         :desc => "The scope to copy views to"

        class_option :views, aliases: "-v", type: :array, desc: "Select specific view directories to generate (application, blog_posts, blogs, comments, dashboard, pages, posts, sites, snippets, subscription_mailer, subscriptions)"

        public_task :copy_views
      end

      module ClassMethods
        def hide!
          Rails::Generators.hide_namespace self.namespace
        end
      end

      def copy_views
        if options[:views]
          options[:views].each do |directory|
            view_directory directory.to_sym
          end
        else
          view_directory :application
          view_directory :blog_posts
          view_directory :blogs
          view_directory :comments
          view_directory :pages
          view_directory :posts
          view_directory :sites
          view_directory :snippets
          view_directory :subscription_mailer
          view_directory :subscriptions
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
    end
  end
end