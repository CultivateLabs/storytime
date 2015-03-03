module Storytime
  module Concerns
    module StorytimeAdminModel
      extend ActiveSupport::Concern

      module ClassMethods
        def storytime_admin_model(opts = {})
          opts[:scope] ||= ->(opts) { all }
          scope :storytime_admin_scope, opts[:scope]
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Storytime::Concerns::StorytimeAdminModel