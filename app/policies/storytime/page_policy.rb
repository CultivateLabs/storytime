module Storytime
  class PagePolicy
    attr_reader :user, :page

    def initialize(user, page)
      @user = user
      @page = page
    end

    def index?
      !@user.nil?
    end

    def create?
      @page.user == @user
    end

    def new?
      create?
    end

    def update?
      true
    end

    def edit?
      update?
    end

    def destroy?
      true
    end
  end
end
