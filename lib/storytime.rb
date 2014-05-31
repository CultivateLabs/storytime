require "storytime/engine"

module Storytime
  class << self
    attr_accessor :layout, :user_class, :media_storage, :s3_bucket
    # TO DO: proper way to set defaults for config options
    def configure
      yield self
    end

    def user_class_symbol
      user_class.to_s.underscore.to_sym
    end
    
  end
end
