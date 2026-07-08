module Storytime
  # Artifacts are arbitrary HTML/JS served from the site origin, so authoring is
  # restricted to users who can manage site settings (admins) rather than any
  # signed-in member. This keeps a low-privilege writer from planting an
  # executable page under the production domain.
  class ArtifactPolicy
    attr_reader :user, :artifact

    def initialize(user, artifact)
      @user = user
      @artifact = artifact
    end

    def index?
      manage?
    end

    def new?
      manage?
    end

    def create?
      manage?
    end

    def edit?
      manage?
    end

    def update?
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
