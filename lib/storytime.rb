require "storytime/engine"

module Storytime
  class << self
    attr_accessor :layout, :user_class, :media_storage, :s3_bucket
    # TO DO: proper way to set defaults for config options
    def configure
      yield self
    end
  end
end
