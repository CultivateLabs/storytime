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
      is_owner? || (@user && (@user.storytime_admin? || @user.storytime_editor?))
    end

    def permitted_attributes
      [:content]
    end
  end
end
