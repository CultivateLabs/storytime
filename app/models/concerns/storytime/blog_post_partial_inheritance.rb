module Storytime::BlogPostPartialInheritance
  extend ActiveSupport::Concern

  included do 
    def to_partial_path
      self.class._to_partial_path
    end
  end

  module ClassMethods
    def _to_partial_path
      @_to_partial_path ||= begin
        element = ActiveSupport::Inflector.underscore(ActiveSupport::Inflector.demodulize(self))
        collection = ActiveSupport::Inflector.tableize(self)
        if File.exists?(Rails.root.join('app', 'views', 'storytime', collection, "_#{element}.html.erb")) ||
           self.superclass == ActiveRecord::Base
          "#{collection}/#{element}"
        else
          "blog_posts/blog_post"
        end
      end
    end
  end
end