require_dependency "storytime/application_controller"

module Storytime
  class BlogsController < ApplicationController
    before_action :load_page

    def show
      if params[:preview].nil? && ((params[:id] != @page.slug) && (request.path != "/"))
        return redirect_to @page, :status => :moved_permanently
      end
      
      @posts = Storytime::BlogPost.primary_feed #TODO: type based on blog settings
      @posts = Storytime.search_adapter.search(params[:search], get_search_type) if (params[:search] && params[:search].length > 0)
      @posts = @posts.tagged_with(params[:tag]) if params[:tag]
      @posts = @posts.published.order(published_at: :desc).page(params[:page])

      #allow overriding in the host app
      render @page.slug if lookup_context.template_exists?("storytime/pages/#{@page.slug}")
    end

  private
    def load_page
      @page = if params[:preview]
        page = Post.find_preview(params[:id])
        page.content = page.autosave.content
        page.preview = true
        page
      else
        Post.published.friendly.find(params[:id])
      end
    end
  end
end
