module Storytime
  class PostPolicy
    attr_reader :user, :record

    class Scope < Struct.new(:user, :scope)
      def resolve
        action = Storytime::Action.find_by(guid: "d8a1b1")
        if user.storytime_role_in_site(Storytime::Site.current).allowed_actions.include?(action)
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

    def show?
      if @post.preview
        manage?
      else
        true
      end
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

        if @user.nil?
          false
        else
          role = @user.storytime_role_in_site(Storytime::Site.current)
          role.present? && role.allowed_actions.include?(action)
        end
      end
    end

    def publish?
      action = if @user == @post.user
        Storytime::Action.find_by(guid: "5030ed")
      else
        Storytime::Action.find_by(guid: "d8a1b1")
      end

      if @user.nil?
        false
      else
        role = user.storytime_role_in_site(Storytime::Site.current)
        role && role.allowed_actions.include?(action)
      end
    end

    def permitted_attributes
      attrs = [:title, :draft_content, :draft_version_id, :excerpt, :featured_media_id, :secondary_media_id, :slug, :published_at_date, :notifications_enabled, :published_at_time, {:tag_list => []}]
      attrs << :published if publish?
      attrs
    end
  end
end
