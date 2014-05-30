module Storytime
  class SitePolicy
    attr_reader :user, :site

    def initialize(user, site)
      @user = user
      @site = site
    end

    def manage?
      action = Storytime::Action.find_by(guid: "47342a")
      @user.storytime_role.present? && @user.storytime_role.allowed_actions.include?(action)
    end

    def create?
      !Site.any?
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
