Storytime.configure do |config|
  # Name of layout to be used.
  config.layout = 'application'

  # Name of the model you're using for Storytime users.
  config.user_class = 'User'

  # Character limit for Storytime::Post.title <= 255
  # config.post_title_character_limit = 255

  # Character limit for Storytime::Post.excerpt <= 255
  # config.post_excerpt_character_limit = 255

  # Path of Storytime's dashboard, relative to
  # Storytime's mount point within the host app.
  # config.dashboard_namespace_path = "/storytime"

  # Path of Storytime's home page, relative to
  # Storytime's mount point within the hose app.
  # config.home_page_path = "/"

  # File upload options.
  config.enable_file_upload = true

  if Rails.env.production?
    config.s3_bucket = 'my-s3-bucket'
    config.media_storage = :s3
  else
    config.media_storage = :file
  end
end