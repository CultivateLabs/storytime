module Storytime
  class SitePolicy
    attr_reader :user, :site

    def initialize(user, site)
      @user = user
      @site = site
    end

    def manage?
      action = Storytime::Action.find_by(guid: "47342a")
      role = @user.storytime_role_in_site(Storytime::Site.current)
      role.present? && role.allowed_actions.include?(action)
    end

    def create?
      true # !Site.any?
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

    def destroy?
      manage?
    end
  end
end
