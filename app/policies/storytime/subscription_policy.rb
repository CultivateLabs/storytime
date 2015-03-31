module Storytime
  class SubscriptionPolicy
    attr_reader :user, :record

    def initialize(user, record)
      @user = user
      @post = record
    end

    def index?
      manage?
    end

    def new?
      manage?
    end

    def create?
      manage?
    end

    def edit?
      manage?
    end

    def update?
      manage?
    end

    def destroy?
      manage?
    end

    def manage?
      action = Storytime::Action.find_by(guid: "d29d76")
      role = @user.storytime_role_in_site(Storytime::Site.current)
      role.present? && role.allowed_actions.include?(action)
    end

    def permitted_attributes
      [:email, :subscribed]
    end
  end
end