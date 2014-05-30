class UserPolicy
  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def manage?
    action = Storytime::Action.find_by(guid: "1f7d47")
    @current_user.storytime_role.present? && @current_user.storytime_role.allowed_actions.include?(action)
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

  def destroy?
    manage?
  end
end

