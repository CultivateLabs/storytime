module Storytime
  class AdminPolicy
    attr_reader :user, :resource

    def initialize(user, resource)
      @user = user
      @resource = resource
    end

    def create?
      true
    end

    def read?
      true
    end

    def update?
      true
    end

    def destroy?
      true
    end
  end
end
