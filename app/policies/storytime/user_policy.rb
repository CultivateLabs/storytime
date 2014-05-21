module Storytime
  class UserPolicy
    attr_reader :current_user, :user

    def initialize(current_user, user)
      @current_user = current_user
      @user = user
    end

    def manage?
      @current_user.role.present? && @current_user.role.allowed_actions.include?(Storytime::Action.find_by(name: "Manage Users"))
    end

    def index?
      manage?
    end

    def edit?
      manage?
    end

    def update?
      manage?
    end

    def new?
      manage?
    end

    def create?
      manage?
    end

    def destroy?
      manage?
    end
  end
end
