module Storytime
  class PagePolicy
    attr_reader :user, :page

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
      manage?
    end

    def edit?
      manage?
    end

    def destroy?
      manage?
    end

    def manage?
      if @user == @page.user
        true
      else
        action = Storytime::Action.find_by(name: "Manage Others' Posts/Pages")
        @user.role.allowed_actions.include?(action)
      end
    end

    def publish?
      action = if @user == @page.user
        Storytime::Action.find_by(name: "Publish Own Posts/Pages")
      else
        Storytime::Action.find_by(name: "Manage Others' Posts/Pages")
      end
      @user.role.allowed_actions.include?(action)
    end

    def permitted_attributes
      if publish?
        [:title, :draft_content, :draft_version_id, :published]
      else
        [:title, :draft_content, :draft_version_id]
      end
    end
  end
end
