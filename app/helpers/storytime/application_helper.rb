module Storytime
  module ApplicationHelper

    def dashboard_nav_site_path(site)
      site.nil? || site.new_record? ? storytime.new_dashboard_site_path : storytime.edit_dashboard_site_path(site)
    end

    def active_nav_item_class(controller)
      unless ["storytime/pages", "storytime/posts"].include? params[:controller]
        'class="active"'.html_safe if controller == params[:controller].split("/").last
      end
    end

    def delete_resource_link(resource, href = nil, remote = true)
      resource_name = resource.class.to_s.downcase.split("::").last
      opts = {
        id: "delete_#{resource_name}_#{resource.id}", 
        class: "btn btn-danger btn-xs btn-delete-resource delete-#{resource_name}-button", 
        data: { confirm: I18n.t('common.are_you_sure_you_want_to_delete', resource_name: resource_name), resource_id: resource.id, resource_type: resource_name },
        method: :delete
      }

      if remote
        opts[:remote] = true
      end
      
      link_to content_tag(:span, "", class: "glyphicon glyphicon-trash"), href || resource, opts
    end
    
    def tag_cloud(tags, classes)
      max = tags.sort_by(&:count).last
      tags.each do |tag|
        index = tag.count.to_f / max.count * (classes.size - 1)
        yield(tag, classes[index.round])
      end
    end
  end
end
