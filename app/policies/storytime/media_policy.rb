module Storytime
  class MediaPolicy
    attr_reader :user, :media

    def initialize(user, media)
      @user = user
      @media = media
    end

    def index?
      !@user.nil?
    end

    def create?
      @media.user == @user
    end

    def destroy?
      return false if @user.nil?

      role = @user.storytime_role_in_site(Storytime::Site.current)
      return false if role.nil?

      @media.user == @user || role.allowed_actions.exists?(guid: "d8a1b1")
    end
  end
end
