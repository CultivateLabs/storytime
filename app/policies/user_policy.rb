class UserPolicy
  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def manage?
    action = Storytime::Action.find_by(guid: "1f7d47")
    role = @current_user.storytime_role_in_site(Storytime::Site.current)
    role.present? && role.allowed_actions.include?(action)
  end

  def index?
    manage?
  end

  def edit?
    manage?
  end

  def update?
    manage?
  end

  def new?
    manage?
  end

  def create?
    manage?
  end
end

