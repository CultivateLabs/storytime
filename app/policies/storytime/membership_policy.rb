module Storytime
  class MembershipPolicy
    attr_reader :user, :record

    def initialize(user, record)
      @user = user
      @membership = record
    end

    def create?
      true
    end

    def permitted_attributes
      [:user_id, :storytime_role_id]
    end
  end
end
