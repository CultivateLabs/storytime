Storytime.configure do |config|
  # Name of the layout to be used. e.g. the 'application'
  # layout uses /app/views/layout/application, in your
  # host app, as the layout.
  # config.layout = 'application'

  # Name of the model you're using for Storytime users.
  config.user_class = 'User'

  # Path of Storytime's dashboard, relative to
  # Storytime's mount point within the host app.
  # config.dashboard_namespace_path = "/storytime"

  # Path of Storytime's home page, relative to
  # Storytime's mount point within the host app.
  # config.home_page_path = "/"

  # Add custom post types to use within Storytime.
  # Make sure that the custom post types inherit the
  # from the Storytime::Post class.
  config.post_types += ['VideoPost']

  # Character limit for Storytime::Post.title <= 255
  # config.post_title_character_limit = 255

  # Character limit for Storytime::Post.excerpt
  # config.post_excerpt_character_limit = 500

  # Array of tags to allow from the Summernote WYSIWYG Editor.
  # An empty array or nil setting will allow all tags.
  # config.whitelisted_html_tags = %w(p blockquote pre h1 h2 h3 h4 h5 h6 span ul li ol table tbody td br a img iframe hr)

  # Enable Disqus comments using your forum's shortname,
  # the unique identifier for your website as registered on Disqus.
  # config.disqus_forum_shortname = ""

  # Search adapter to use for searching through Storytime Posts or
  # Post subclasses. Options for the search adapter include:
  # Storytime::PostgresSearchAdapter, Storytime::MysqlSearchAdapter,
  # Storytime::MysqlFulltextSearchAdapter, Storytime::Sqlite3SearchAdapter
  config.search_adapter = Storytime::Sqlite3SearchAdapter

  # File upload options.
  config.enable_file_upload = true

  config.admin_models = ["Widget"]

  if Rails.env.production?
    config.s3_bucket = 'my-s3-bucket'
    config.media_storage = :s3
  else
    config.media_storage = :file
  end
end
