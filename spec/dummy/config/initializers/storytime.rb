Storytime.configure do |config|
  # Name of layout to be used.
  # config.layout = 'application'

  # Name of the model you're using for Storytime users.
  config.user_class = 'User'

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