module Storytime
  class UserPolicy
    attr_reader :current_user, :user

    def initialize(current_user, user)
      @current_user = current_user
      @user = user
    end

    def index?
      @current_user.admin?
    end

    def edit?
      @current_user.admin?
    end

    def update?
      edit?
    end

    def new?
      @current_user.admin?
    end

    def create?
      new?
    end

    def destroy?
      @current_user.admin?
    end
  end
end
