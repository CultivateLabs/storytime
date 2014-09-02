module Storytime
  module Dashboard
    module PostsHelper
      def post_list_title(post_type)
        post_type.type_name.humanize
      end
    end
  end
end