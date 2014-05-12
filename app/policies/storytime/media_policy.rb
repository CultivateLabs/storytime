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
      true
    end
  end
end
