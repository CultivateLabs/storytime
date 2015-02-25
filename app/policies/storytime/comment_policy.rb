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

    def create?
      is_owner?
    end

    def destroy?
      is_owner? || (@user && (@user.storytime_admin?(@comment.site) || @user.storytime_editor?(@comment.site)))
    end

    def permitted_attributes
      [:content]
    end
  end
end
