require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class PagesController < PostsController

    private

      def current_post_type
        Storytime::Page
      end

    end
  end
end
