module ActionDispatch
  module Routing
    class RouteSet
      
      def url_for_with_storytime(options = {})
        if options[:controller] == "storytime/posts" && options[:action] == "index"
          options[:use_route] = "root_post_index" if Storytime::Site.first.root_page_content == "posts"
        elsif options[:controller] == "storytime/posts" && options[:action] == "show"
          site = Storytime::Site.first
          key = [:id, :component_1, :component_2, :component_3].detect{|key| options[key].class == Storytime::Post }
          post = options[key]

          case site.post_slug_style
          when "default"
            options[:id] = post
            options[:component_1] = "posts"
          when "day_and_name" 
            date = post.created_at.to_date
            options[:component_1] = date.year
            options[:component_2] = date.month
            options[:component_3] = date.day
            options[:id] = post
          when "month_and_name"
            date = post.created_at.to_date
            options[:component_1] = date.year
            options[:component_2] = date.month
            options[:id] = post
          when "post_name"
            options[:component_1] = nil
            options[:id] = post
          end
        end

        url_for_without_storytime(options)
      rescue Exception => e
        # binding.pry
      end

      alias_method_chain :url_for, :storytime
    end
  end
end

