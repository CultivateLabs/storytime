require "storytime/engine"

module Storytime
  class << self
    attr_accessor :layout, :user_class, :media_storage, :s3_bucket, :post_types
    # TO DO: proper way to set defaults for config options
    def configure
      self.post_types ||= []
      yield self
    end

    def user_class_symbol
      user_class.to_s.underscore.to_sym
    end
    
  end
end
