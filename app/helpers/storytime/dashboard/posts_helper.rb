module Storytime
  module Dashboard
    module PostsHelper
      def new_post_button(post_type)
        if post_type.excluded_from_primary_feed? || post.included_in_primary_feed.count == 1
          render "basic_new_post_button", post_type: post_type
        else
          render "new_post_dropdown_button", post_type: post_type
        end
      end

      def post_list_title(post_type)
        if post_type.excluded_from_primary_feed?
          post_type.name
        else
          "Blog Posts"
        end.humanize.pluralize
      end
    end
  end
end