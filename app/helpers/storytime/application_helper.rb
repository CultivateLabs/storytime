module Storytime
  module ApplicationHelper

    def active_nav_item_class(controller)
      'class="active"'.html_safe if controller == params[:controller].split("/").last
    end

    def delete_resource_link(resource, href = nil)
      resource_name = resource.class.to_s.downcase.split("::").last
      opts = {
        id: "delete_#{resource_name}_#{resource.id}", 
        class: "btn btn-danger btn-xs btn-delete-resource delete-#{resource_name}-button", 
        data: { confirm: I18n.t('common.are_you_sure_you_want_to_delete', resource_name: resource_name), resource_id: resource.id, resource_type: resource_name },
        method: :delete,
        remote: true
      }
      
      link_to content_tag(:span, "", class: "glyphicon glyphicon-trash"), href || resource, opts
    end

  end
end
