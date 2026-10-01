# encoding: utf-8

module Storytime
  class MediaUploader < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick

    def extension_allowlist
      %w[jpg jpeg png gif webp]
    end

    def content_type_allowlist
      %w[image/jpeg image/png image/gif image/webp]
    end

    def size_range
      1..10.megabytes
    end

    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
    
    version :thumb do
      process resize_to_fit: [250, 150]
    end

    version :tiny do
      process resize_to_fit: [50, 50]
    end

  end
end