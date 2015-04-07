Storytime.configure do |config|
  # Name of the model you're using for Storytime users.
  config.user_class = 'User'

  # Path of Storytime's dashboard, relative to
  # Storytime's mount point within the host app.
  # config.dashboard_namespace_path = "/storytime"

  # Add custom post types to use within Storytime.
  # Make sure that the custom post types inherit the
  # from the Storytime::Post class.
  config.post_types += ['VideoPost']

  # Character limit for Storytime::Post.title <= 255
  # config.post_title_character_limit = 255

  # Character limit for Storytime::Post.excerpt
  # config.post_excerpt_character_limit = 500

  # Enable Disqus comments using your forum's shortname,
  # the unique identifier for your website as registered on Disqus.
  # config.disqus_forum_shortname = ""

  # Enable Discourse comments using your discourse server,
  # Your discourse server must be configured for embedded comments.
  # e.g. config.discourse_name = "http://forum.example.com/"
  # NOTE:  include the '/' suffix at the end of the url
  # config.discourse_name = ""

  # Search adapter to use for searching through Storytime Posts or
  # Post subclasses. Options for the search adapter include:
  # Storytime::PostgresSearchAdapter, Storytime::MysqlSearchAdapter,
  # Storytime::MysqlFulltextSearchAdapter, Storytime::Sqlite3SearchAdapter
  config.search_adapter = Storytime::Sqlite3SearchAdapter

  # File upload options.
  config.enable_file_upload = true

  if Rails.env.production?
    config.s3_bucket = 'my-s3-bucket'
    config.media_storage = :s3
  else
    config.media_storage = :file
  end
end
