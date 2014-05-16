module Storytime
  class VersionPolicy
    attr_reader :user, :version

    def initialize(user, version)
      @user = user
      @version = version
    end

    def revert?
      !@user.nil?
    end
  end
end