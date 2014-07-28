require_dependency "storytime/application_controller"

module Storytime
  class PagesController < ApplicationController
    before_action :ensure_site, unless: ->{ params[:controller] == "storytime/dashboard/sites" }
    def show
      params[:id] = @site.selected_root_page_id if request.path == "/"
      
      @page = Page.published.friendly.find(params[:id])

      if request.path != page_path(@page)
        return redirect_to @page, :status => :moved_permanently
      end

      #allow overriding in the host app
      render @page.slug if lookup_context.template_exists?("storytime/pages/#{@page.slug}")
    end
  end
end