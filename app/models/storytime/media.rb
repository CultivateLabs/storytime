module Storytime
  class Media < ActiveRecord::Base
    belongs_to :user

    mount_uploader :file, MediaUploader
  end
end
