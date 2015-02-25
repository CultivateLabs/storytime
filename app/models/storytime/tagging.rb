module Storytime
  class Tagging < ActiveRecord::Base
    include Storytime::ScopedToSite
    belongs_to :tag
    belongs_to :post
  end
end
