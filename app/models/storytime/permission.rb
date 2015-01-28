module Storytime
  class Permission < ActiveRecord::Base
    belongs_to :role
    belongs_to :action

    def self.seed
      writer = Role.find_by(name: "writer")
      editor = Role.find_by(name: "editor")
      admin  = Role.find_by(name: "admin")

      publish_own         = Action.find_by(guid: "5030ed")
      manage_others       = Action.find_by(guid: "d8a1b1")
      manage_site         = Action.find_by(guid: "47342a")
      manage_users        = Action.find_by(guid: "1f7d47")
      manage_snippets     = Action.find_by(guid: "5qg25i")
      manage_admin_models = Action.find_by(guid: "3fj09k")

      find_or_create_by(role: writer, action: publish_own)
      find_or_create_by(role: editor, action: publish_own)
      find_or_create_by(role: admin, action: publish_own)

      find_or_create_by(role: editor, action: manage_others)
      find_or_create_by(role: admin, action: manage_others)

      find_or_create_by(role: admin, action: manage_site)
      find_or_create_by(role: admin, action: manage_users)

      find_or_create_by(role: editor, action: manage_snippets)
      find_or_create_by(role: admin, action: manage_snippets)
      
      find_or_create_by(role: admin, action: manage_admin_models)
    end
  end
end
