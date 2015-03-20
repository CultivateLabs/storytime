module Storytime
  class CommentPolicy
    attr_reader :user, :comment

    def initialize(user, comment)
      @user = user
      @comment = comment
    end

    def is_owner?
      @comment.user == @user
    end

    def is_admin_or_editor?
      (@user && (@user.storytime_admin?(@comment.site) || @user.storytime_editor?(@comment.site)))
    end

    def create?
      is_owner?
    end

    def destroy?
      is_owner? || is_admin_or_editor?
    end

    def permitted_attributes
      [:content]
    end
  end
end
