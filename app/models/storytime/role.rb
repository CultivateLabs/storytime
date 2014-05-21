module Storytime
  class Role < ActiveRecord::Base
    has_many :users
    has_many :permissions
    has_many :allowed_actions, through: :permissions, source: :action

    def label
      name.humanize
    end
  end
end
