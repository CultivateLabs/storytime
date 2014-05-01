module Storytime
  module ApplicationHelper

    def active_nav_item_class(path)
      'class="active"'.html_safe if path == request.path
    end

  end
end
