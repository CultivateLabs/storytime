module Storytime
  module Importers
    class ImporterPolicy
      attr_reader :user

      def initialize(user, klass)
        @user = user
      end

      def new?
        create?
      end

      def create?
        !@user.nil?
      end
    end
  end
end
