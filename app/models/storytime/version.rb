module Storytime
  class Version < ActiveRecord::Base
    belongs_to :user
    belongs_to :versionable, polymorphic: true
  end
end
