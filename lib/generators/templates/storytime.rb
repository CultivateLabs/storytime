Storytime.configure do |config|
  # Name of the layout to be used. e.g. the 'application'
  # layout uses /app/views/layout/application, in your
  # host app, as the layout.
  <%= @enable_layout ? nil : '# ' %>config.layout = '<%= @layout %>'

  # Name of the model you're using for Storytime users.
  <%= @enable_user_class ? nil : '# ' %>config.user_class = '<%= @user_class %>'

  # Path of Storytime's dashboard, relative to
  # Storytime's mount point within the host app.
  <%= @enable_dashboard_namespace_path ? nil : '# ' %>config.dashboard_namespace_path = '<%= @dashboard_namespace_path %>'

  # Path of Storytime's home page, relative to
  # Storytime's mount point within the host app.
  <%= @enable_home_page_path ? nil : '# ' %>config.home_page_path = '<%= @home_page_path %>'

  # Path used to sign users in. 
  # config.login_path = '/users/sign_in'

  # Path used to log users out. 
  # config.logout_path = '/users/sign_out'

  # Method used for Storytime user logout path.
  # config.logout_method = :delete

  # Add custom post types to use within Storytime.
  # Make sure that the custom post types inherit the
  # from the Storytime::Post class.
  <%= @enable_post_types ? nil : '# ' %>config.post_types += <%= @post_types %>

  # Character limit for Storytime::Post.title <= 255
  <%= @enable_post_title_character_limit ? nil : '# ' %>config.post_title_character_limit = <%= @post_title_character_limit %>

  # Character limit for Storytime::Post.excerpt
  <%= @enable_post_excerpt_character_limit ? nil : '# ' %>config.post_excerpt_character_limit = <%= @post_excerpt_character_limit %>

  # Array of tags to allow from the Summernote WYSIWYG Editor.
  # An empty array or nil setting will allow all tags.
  <%= @enable_whitelisted_html_tags ? nil : '# ' %>config.whitelisted_html_tags = <%= @whitelisted_html_tags %>

  # Enable Disqus comments using your forum's shortname,
  # the unique identifier for your website as registered on Disqus.
  <%= @enable_disqus_forum_shortname ? nil : '# ' %>config.disqus_forum_shortname = '<%= @disqus_forum_shortname %>'

  # Email regex used to validate email format validity for subscriptions.
  <%= @enable_email_regexp ? nil : '# ' %>config.email_regexp = <%= @email_regexp %>

  # Search adapter to use for searching through Storytime Posts or
  # Post subclasses. Options for the search adapter include:
  # Storytime::PostgresSearchAdapter, Storytime::MysqlSearchAdapter,
  # Storytime::MysqlFulltextSearchAdapter, Storytime::Sqlite3SearchAdapter
  <%= @enable_search_adapter ? nil : '# ' %>config.search_adapter = <%= @search_adapter %>

  # File upload options.
  config.enable_file_upload = <%= @enable_file_upload %>

  if Rails.env.production?
    config.media_storage = <%= @prod_media_storage %>
    <%= @enable_file_upload && @prod_media_storage == ':s3' ? nil : '# ' %>config.s3_bucket = '<%= @s3_bucket %>'
  else
    config.media_storage = <%= @dev_media_storage %>
  end
end
