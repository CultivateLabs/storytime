module Storytime
  # API tokens grant programmatic artifact creation, so they are restricted to
  # users who can manage site settings (admins), matching ArtifactPolicy.
  class ApiTokenPolicy
    attr_reader :user, :api_token

    def initialize(user, api_token)
      @user = user
      @api_token = api_token
    end

    def index?
      manage?
    end

    def create?
      manage?
    end

    def destroy?
      manage?
    end

    def manage?
      return false if @user.nil?

      action = Storytime::Action.find_by(guid: "47342a")
      role = @user.storytime_role_in_site(Storytime::Site.current)
      role.present? && role.allowed_actions.include?(action)
    end
  end
end
