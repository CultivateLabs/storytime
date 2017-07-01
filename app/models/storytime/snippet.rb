module Storytime
  class Snippet < ActiveRecord::Base
    include Storytime::ScopedToSite
    belongs_to :site

    validates :name, length: { in: 1..255 }
    validates :content, length: { in: 1..20000 }
  end
end
