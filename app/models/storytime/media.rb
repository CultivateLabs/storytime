module Storytime
  class Media < ActiveRecord::Base
    belongs_to Storytime.user_class_symbol

    mount_uploader :file, MediaUploader
  end
end
