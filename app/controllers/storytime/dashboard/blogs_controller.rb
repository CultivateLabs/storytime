module Storytime
  module Dashboard
    class BlogsController < PostsController
      
    private
      def current_post_type
        @current_post_type ||= Storytime::Blog
      end
      helper_method :current_post_type
    end
  end
end