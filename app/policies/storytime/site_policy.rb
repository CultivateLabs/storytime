module Storytime
  class SitePolicy
    attr_reader :user, :site

    def initialize(user, site)
      @user = user
      @site = site == Storytime::Site ? Storytime::Site.current : site
    end

    def manage?
      return false if @user.nil? || @site.nil? || @site.id != Storytime::Site.current_id

      action = Storytime::Action.find_by(guid: "47342a")
      role = @user.storytime_role_in_site(Storytime::Site.current)
      role.present? && role.allowed_actions.include?(action)
    end

    def create?
      @user.present? && (Storytime::Site.none? ||
        (Storytime.site_creation_authorizer && Storytime.site_creation_authorizer.call(@user)))
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
