module Storytime
  class Action < ActiveRecord::Base
    has_many :permissions
    has_many :roles, through: :permissions

    validates :guid, uniqueness: true
    validates :name, uniqueness: true

    def self.seed
      find_by(guid: "d8a1b1") || create(guid: "d8a1b1", name: "Manage Other People's Posts/Pages")
      find_by(guid: "5030ed") || create(guid: "5030ed", name: "Publish Own Posts/Pages")
      find_by(guid: "47342a") || create(guid: "47342a", name: "Manage Site Settings")
      find_by(guid: "1f7d47") || create(guid: "1f7d47", name: "Manage Users")
      find_by(guid: "5qg25i") || create(guid: "5qg25i", name: "Manage Text Snippets")
      find_by(guid: "d29d76") || create(guid: "d29d76", name: "Manage Email Subscriptions")
      find_by(guid: "3fj09k") || create(guid: "3fj09k", name: "Access Admin Section")
    end
  end
end
