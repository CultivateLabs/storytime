CarrierWave.configure do |config|
  if Storytime.media_storage == :s3
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['STORYTIME_AWS_ACCESS_KEY_ID'],
      :aws_secret_access_key  => ENV['STORYTIME_AWS_SECRET_KEY']
    }
    config.fog_directory  = Storytime.s3_bucket
    config.fog_public     = true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  else
    config.storage = :file
  end
  
  config.enable_processing = !Rails.env.test?
end