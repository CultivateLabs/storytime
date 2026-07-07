module Storytime
  class ArtifactPolicy
    attr_reader :user, :artifact

    def initialize(user, artifact)
      @user = user
      @artifact = artifact
    end

    def index?
      !@user.nil?
    end

    def new?
      !@user.nil?
    end

    def create?
      !@user.nil?
    end

    def edit?
      !@user.nil?
    end

    def update?
      !@user.nil?
    end

    def destroy?
      !@user.nil?
    end
  end
end
