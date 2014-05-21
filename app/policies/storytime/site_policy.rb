module Storytime
  class SitePolicy
    attr_reader :user, :site

    def initialize(user, site)
      @user = user
      @site = site
    end

    def create?
      @user.admin && !Storytime::Site.exists?
    end

    def new?
      create?
    end

    def update?
      @user.admin?
    end

    def edit?
      update?
    end
  end
end
