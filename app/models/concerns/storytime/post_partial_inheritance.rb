module Storytime::PostPartialInheritance
  extend ActiveSupport::Concern

  module ClassMethods

    # Tries to render the appropriate partial, respecting inheritance and per-site overrides
    # Order of preference (lowest is last) looks something like:
    # storytime/views/site-name/blog_posts/blog_post
    # storytime/views/blog_posts/blog_post
    # storytime/views/site-name/posts/post
    # storytime/views/post/post
    def _to_partial_path(site)
      @_to_partial_path ||= begin
        element = ActiveSupport::Inflector.underscore(ActiveSupport::Inflector.demodulize(self))
        collection = ActiveSupport::Inflector.tableize(self.to_s)
        
        if site && File.exists?(Rails.root.join('app', 'views', "storytime/#{site.custom_view_path}/#{collection.sub("storytime/", "")}/_#{element}.html.erb"))
          "storytime/#{site.custom_view_path}/#{collection.sub("storytime/", "")}/#{element}"
        elsif File.exists?(Rails.root.join('app', 'views', collection, "_#{element}.html.erb")) ||
              self.superclass == ActiveRecord::Base
          "#{collection}/#{element}"
        else
          self.superclass._to_partial_path(site)
        end
      end
    end

  end
end