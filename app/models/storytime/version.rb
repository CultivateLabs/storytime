module Storytime
  class Version < ActiveRecord::Base
    belongs_to Storytime.user_class_symbol
    belongs_to :versionable, polymorphic: true
  end
end
