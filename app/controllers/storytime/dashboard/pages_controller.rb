require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class PagesController < PostsController

    private

      def load_posts
        @posts = base_posts_scope.where(type: "Storytime::Page")
      end

      def new_post
        page = Storytime::Page.new(post_params)
        page.user = current_user
        page
      end

    end
  end
end
