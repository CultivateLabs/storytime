module Storytime
  class PostPolicy
    attr_reader :user, :record

    class Scope < Struct.new(:user, :scope)
      def resolve
        action = Storytime::Action.find_by(guid: "d8a1b1")
        if user.storytime_role.allowed_actions.include?(action)
          scope.all
        else
          scope.where(user_id: user.id)
        end
      end
    end

    def initialize(user, record)
      @user = user
      @post = record
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
        action = Storytime::Action.find_by(guid: "d8a1b1")
        @user.storytime_role.allowed_actions.include?(action)
      end
    end

    def publish?
      action = if @user == @post.user
        Storytime::Action.find_by(guid: "5030ed")
      else
        Storytime::Action.find_by(guid: "d8a1b1")
      end
      @user.storytime_role.allowed_actions.include?(action)
    end

    def permitted_attributes
      attrs = [:title, :draft_content, :draft_version_id, :excerpt, :post_type, :tag_list, :post_type_id]
      attrs << :published if publish?
      attrs
    end
  end
end
