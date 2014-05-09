require "storytime/engine"

module Storytime
  class << self
    attr_accessor :layout
    # TO DO: proper way to set defaults for config options
    def configure
      yield self
    end
  end
end
