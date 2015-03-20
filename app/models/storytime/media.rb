module Storytime
  class Media < ActiveRecord::Base
    include Storytime::ScopedToSite
    belongs_to :user, class_name: Storytime.user_class
    has_many :posts # posts where this is the featured media
    belongs_to :site

    mount_uploader :file, MediaUploader
  end
end
