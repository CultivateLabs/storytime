module Storytime
  module PostUrlHandler

    def self.handle_url(options)
      return unless options[:controller] == "storytime/posts" && options[:action] == "show"

      key = [:id, :component_1, :component_2, :component_3].detect{|key| options[key].is_a?(Storytime::Post) }
      post = options[key]

      if post.is_a?(Storytime::Page)
        options[:component_1] = nil
        options[:id] = post
      else
        case post.site.post_slug_style
        when "default"
          options[:component_1] = "posts"
          options[:id] = post
        when "day_and_name" 
          date = post.created_at.to_date
          options[:component_1] = date.strftime("%Y") # 4 digit year
          options[:component_2] = date.strftime("%m") # 2 digit month
          options[:component_3] = date.strftime("%d") # 2 digit day
          options[:id] = post
        when "month_and_name"
          date = post.created_at.to_date
          options[:component_1] = date.strftime("%Y") # 4 digit year
          options[:component_2] = date.strftime("%m") # 2 digit month
          options[:id] = post
        when "post_id"
          options[:component_1] = "posts"
          options[:id] = post.id
        end
      end
    
    end

    def self.site(options)
      if Storytime::Site.current_id.present? 
        Storytime::Site.find(Storytime::Site.current_id)
      elsif options[:host]
        Storytime::Site.find_by!(custom_domain: options[:host])
      end
    end
      

  end
end