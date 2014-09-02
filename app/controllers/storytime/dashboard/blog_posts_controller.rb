require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class BlogPostsController < PostsController

    private

      def load_posts
        @posts = base_posts_scope.where(type: "Storytime::BlogPost")
      end

      def new_post(attrs = nil)
        page = if params[:action] == "new"
          Storytime::BlogPost.new
        else
          Storytime::BlogPost.new(attrs)
        end

        page.user = current_user
        page
      end

      def post_params
        permitted_attrs = policy(@post || current_user.storytime_posts.new).permitted_attributes
        permitted_attrs = permitted_attrs.append(storytime_post_param_additions) if respond_to?(:storytime_blog_post_param_additions)
        params.require(:blog_post).permit(*permitted_attrs)
      end

    end
  end
end
