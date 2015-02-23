module Storytime
  module Dashboard
    class BlogsController < PostsController
      respond_to :json

      def new
        @blog = current_post_type.new
        @blog.user = current_user
        authorize @blog
        respond_with @blog
      end

      def create
        @blog = current_post_type.new(post_params)
        @blog.user = current_user
        @blog.draft_content = "test"
        @blog.draft_user_id = current_user.id
        @blog.published_at = Time.now.utc
        authorize @blog

        respond_with @blog do |format|
          if @blog.save
            format.json { render :index }
          else
            format.json { render :new, status: :unprocessable_entity }
          end
        end
      end
      
    private
      def current_post_type
        @current_post_type ||= Storytime::Blog
      end
      helper_method :current_post_type
    end
  end
end