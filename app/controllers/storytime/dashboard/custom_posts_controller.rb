module Storytime
  module Dashboard
    class CustomPostsController < BlogPostsController
      
    private
      def current_post_type
        type = request.path.split("/")[2].classify
        @current_post_type ||= type.constantize if Storytime.post_types.include?(type)
      end
      helper_method :current_post_type

      def load_posts
        @posts = policy_scope(Storytime::Post).page(params[:page_number]).per(10)
        
        @posts = if current_post_type.included_in_primary_feed?
          @posts.primary_feed
        else
          @posts.where(type: current_post_type)
        end

        @posts = if params[:published].present? && params[:published] == 'true'
          @posts.published.order(published_at: :desc)
        else
          @posts.draft.order(updated_at: :desc)
        end
      end
    end
  end
end