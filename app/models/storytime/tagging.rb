module Storytime
  class Tagging < ActiveRecord::Base
    belongs_to :tag
    belongs_to :post
  end
end
