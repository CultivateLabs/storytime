require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class BlogPostsController < PostsController

    private

      def current_post_type
        Storytime::Page
      end

      def post_params
        permitted_attrs = policy(@post || current_user.storytime_posts.new).permitted_attributes
        permitted_attrs = permitted_attrs.append(storytime_post_param_additions) if respond_to?(:storytime_blog_post_param_additions)
        params.require(:blog_post).permit(*permitted_attrs)
      end

    end
  end
end
