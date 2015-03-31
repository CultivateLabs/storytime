module Storytime
  class Permission < ActiveRecord::Base
    include Storytime::ScopedToSite
    belongs_to :role
    belongs_to :action

    def self.seed
      writer = Role.find_by(name: "writer")
      editor = Role.find_by(name: "editor")
      admin  = Role.find_by(name: "admin")

      publish_own          = Action.find_by(guid: "5030ed")
      manage_others        = Action.find_by(guid: "d8a1b1")
      manage_site          = Action.find_by(guid: "47342a")
      manage_users         = Action.find_by(guid: "1f7d47")
      manage_snippets      = Action.find_by(guid: "5qg25i")
      manage_admin_models  = Action.find_by(guid: "3fj09k")
      manage_subscriptions = Action.find_by(guid: "d29d76")

      Storytime::Site.find_each do |site|
        [
          {role: writer, action: publish_own},
          {role: editor, action: publish_own},
          {role: admin, action: publish_own},
          {role: editor, action: manage_others},
          {role: admin, action: manage_others},
          {role: admin, action: manage_site},
          {role: admin, action: manage_users},
          {role: editor, action: manage_snippets},
          {role: admin, action: manage_snippets},
          {role: admin, action: manage_subscriptions},
          {role: admin, action: manage_admin_models}
        ].each do |perm_attrs|
          perm_attrs[:site_id] = site.id if ActiveRecord::Base.connection.column_exists?(:storytime_permissions, :site_id)
          find_or_create_by(perm_attrs)
        end
      end
    end
  end
end