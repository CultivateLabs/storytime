module Storytime
  class Action < ActiveRecord::Base
    has_many :permissions
    has_many :roles, through: :permissions

    def self.seed
      create(guid: "d8a1b1", name: "Manage Other People's Posts/Pages")
      create(guid: "5030ed", name: "Publish Own Posts/Pages")
      create(guid: "47342a", name: "Manage Site Settings")
      create(guid: "1f7d47", name: "Manage Users")
    end
  end
end
