module Storytime
  class Role < ActiveRecord::Base
    has_many :users
    has_many :permissions
    has_many :allowed_actions, through: :permissions, source: :action

    validates :name, uniqueness: true

    def label
      name.humanize
    end

    def self.seed
      create(name: "writer")
      create(name: "editor")
      create(name: "admin")
    end
  end
end
