require 'thor/group'

module Storytime
  module Generators
    class Initializer < Thor::Group
      include Thor::Actions
      
      argument :settings, :type => :hash

      class_option :force, :type => :boolean, :default => false

      source_root File.expand_path('../../../generators/templates', __FILE__)

      def set_local_assigns
        @layout = settings[:layout]
        @user_class = settings[:user_class]
        @dashboard_namespace_path = settings[:dashboard_namespace_path]
        @home_page_path = settings[:home_page_path]
        @post_types = settings[:post_types]
        @post_title_character_limit = settings[:post_title_character_limit]
        @post_excerpt_character_limit = settings[:post_excerpt_character_limit]
        @whitelisted_html_tags = settings[:whitelisted_html_tags]
        @disqus_forum_shortname = settings[:disqus_forum_shortname]
        @email_regexp = settings[:email_regexp]
        @search_adapter = settings[:search_adapter]
        @enable_file_upload = settings[:enable_file_upload]
        @s3_bucket = settings[:s3_bucket]
        @prod_media_storage = settings[:prod_media_storage]
        @dev_media_storage = settings[:dev_media_storage]

        @enable_layout = settings[:enable_layout]
        @enable_dashboard_namespace_path = settings[:enable_dashboard_namespace_path]
        @enable_home_page_path = settings[:enable_home_page_path]
        @enable_post_types = settings[:enable_post_types]
        @enable_post_title_character_limit = settings[:enable_post_title_character_limit]
        @enable_post_excerpt_character_limit = settings[:enable_post_excerpt_character_limit]
        @enable_whitelisted_html_tags = settings[:enable_whitelisted_html_tags]
        @enable_disqus_forum_shortname = settings[:enable_disqus_forum_shortname]
        @enable_email_regexp = settings[:enable_email_regexp]
        @enable_search_adapter = settings[:enable_search_adapter]
      end

      def copy_initializer
        template "storytime.rb", "storytime_test.rb"
      end
    end
  end
end