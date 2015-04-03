module Storytime
  class Role < ActiveRecord::Base
    has_many :users
    has_many :permissions
    has_many :allowed_actions, through: :permissions, source: :action

    validates :name, uniqueness: true

    def editor?
      name == "editor"
    end

    def writer?
      name == "writer"
    end

    def admin?
      name == "admin"
    end

    def label
      name.humanize
    end

    def self.seed
      find_or_create_by(name: "writer")
      find_or_create_by(name: "editor")
      find_or_create_by(name: "admin")
    end
  end
end
