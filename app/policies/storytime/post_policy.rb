module Storytime
  class PostPolicy
    attr_reader :user, :post

    def initialize(user, post)
      @user = user
      @post = post
    end

    def index?
      !@user.nil?
    end

    def create?
      @post.user == @user
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

    def revert?
      update?
    end

    def destroy?
      true
    end
  end
end
