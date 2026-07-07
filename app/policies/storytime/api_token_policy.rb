module Storytime
  class ApiTokenPolicy
    attr_reader :user, :api_token

    def initialize(user, api_token)
      @user = user
      @api_token = api_token
    end

    def index?
      !@user.nil?
    end

    def create?
      !@user.nil?
    end

    def destroy?
      !@user.nil?
    end
  end
end
