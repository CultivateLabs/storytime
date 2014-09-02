module Storytime
  module Dashboard
    module PostsHelper
      def new_post_button(category)
        if category.nil? || category.excluded_from_primary_feed? || post.included_in_primary_feed.count == 1
          render "basic_new_post_button", category: category
        else
          render "new_post_dropdown_button", category: category
        end
      end

      def post_list_title(category)
        if category && category.excluded_from_primary_feed?
          category.name.humanize.pluralize
        else
          "Blog Posts"
        end
      end
    end
  end
end