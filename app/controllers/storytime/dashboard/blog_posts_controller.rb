require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class BlogPostsController < PostsController

    private

      def current_post_type
        Storytime::BlogPost
      end

    end
  end
end
