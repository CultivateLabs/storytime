module Storytime
  class Media < ActiveRecord::Base
    belongs_to :user, class_name: Storytime.user_class.to_s
    has_many :posts # posts where this is the featured media

    mount_uploader :file, MediaUploader
  end
end
