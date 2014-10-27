module Storytime
  class Snippet < ActiveRecord::Base
    validates :name, length: { in: 1..255 }
    validates :content, length: { in: 1..5000 }
  end
end
