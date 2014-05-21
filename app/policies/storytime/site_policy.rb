module Storytime
  class SitePolicy
    attr_reader :user, :site

    def initialize(user, site)
      @user = user
      @site = site
    end

    def manage?
      @user.role.present? && @user.role.allowed_actions.include?(Storytime::Action.find_by(name: "Manage Site Settings"))
    end

    def create?
      manage?
    end

    def new?
      create?
    end

    def update?
      manage?
    end

    def edit?
      update?
    end
  end
end
