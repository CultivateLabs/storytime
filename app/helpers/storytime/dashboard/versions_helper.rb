module Storytime
  module Dashboard
    module VersionsHelper
      def versions_info(versionable)
        render 'storytime/dashboard/versions/versions_info', versionable: versionable
      end
    end
  end
end