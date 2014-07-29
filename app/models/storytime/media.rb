module Storytime
  class Media < ActiveRecord::Base
    belongs_to Storytime.user_class_symbol
    has_many :posts # posts where this is the featured media

    mount_uploader :file, MediaUploader
  end
end
