module Storytime
  class PostPolicy
    attr_reader :user, :post

    class Scope < Struct.new(:user, :scope)
      def resolve
        action = Storytime::Action.find_by(name: "Manage Others' Posts/Pages")
        if user.role.allowed_actions.include?(action)
          scope.all
        else
          scope.where(user_id: user.id)
        end
      end
    end

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
      manage?
    end

    def edit?
      manage?
    end

    def destroy?
      manage?
    end

    def manage?
      if @user == @post.user
        true
      else
        action = Storytime::Action.find_by(name: "Manage Others' Posts/Pages")
        @user.role.allowed_actions.include?(action)
      end
    end

    def publish?
      action = if @user == @post.user
        Storytime::Action.find_by(name: "Publish Own Posts/Pages")
      else
        Storytime::Action.find_by(name: "Manage Others' Posts/Pages")
      end
      @user.role.allowed_actions.include?(action)
    end

    def permitted_attributes
      if publish?
        [:title, :draft_content, :draft_version_id, :excerpt, :post_type, :tag_list, :published]
      else
        [:title, :draft_content, :draft_version_id, :excerpt, :post_type, :tag_list]
      end
    end
  end
end
