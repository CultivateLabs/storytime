module Storytime
  class Permission < ActiveRecord::Base
    belongs_to :role
    belongs_to :action

    def self.seed
      writer = Role.find_by(name: "writer")
      editor = Role.find_by(name: "editor")
      admin = Role.find_by(name: "admin")

      publish_own = Action.find_by(guid: "5030ed")
      manage_others = Action.find_by(guid: "d8a1b1")
      manage_site = Action.find_by(guid: "47342a")
      manage_users = Action.find_by(guid: "1f7d47")

      create(role: writer, action: publish_own)
      create(role: editor, action: publish_own)
      create(role: admin, action: publish_own)

      create(role: editor, action: manage_others)
      create(role: admin, action: manage_others)

      create(role: admin, action: manage_site)
      create(role: admin, action: manage_users)
    end
  end
end
