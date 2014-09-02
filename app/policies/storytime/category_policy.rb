module Storytime
  class CategoryPolicy
    attr_reader :user, :record

    def initialize(user, record)
      @user = user
      @category = record
    end

    def index?
      manage?
    end

    def create?
      manage?
    end

    def new?
      manage?
    end

    def update?
      manage?
    end

    def edit?
      manage?
    end

    def destroy?
      manage?
    end

    def manage?
      !@user.storytime_role.nil?
    end

    def permitted_attributes
      [:name, :excluded_from_primary_feed]
    end
  end
end
