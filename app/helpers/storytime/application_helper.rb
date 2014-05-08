module Storytime
  module ApplicationHelper

    def active_nav_item_class(controller)
      'class="active"'.html_safe if controller == params[:controller].split("/").last
    end

  end
end
