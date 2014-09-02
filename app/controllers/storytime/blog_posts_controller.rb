require_dependency "storytime/application_controller"

module Storytime
  class BlogPostsController < ApplicationController
    before_action :ensure_site, unless: ->{ params[:controller] == "storytime/dashboard/sites" }

    def index
      @posts = Post.primary_feed
      
      @posts = @posts.tagged_with(params[:tag]) if params[:tag]
      @posts = @posts.published.order(created_at: :desc).page(params[:page]).per(10)
      
      respond_to do |format|
        format.atom
        format.html
      end
    end

    def show
      @post = Post.published.friendly.find(params[:id])
      
      if params[:id] != @post.slug && request.path != "/"
        return redirect_to @post, :status => :moved_permanently
      end

      @comments = @post.comments.order("created_at DESC")

      #allow overriding in the host app
      render @post.slug if lookup_context.template_exists?("storytime/posts/#{@post.slug}")
    end
  end
end
