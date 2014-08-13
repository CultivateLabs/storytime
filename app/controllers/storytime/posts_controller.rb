require_dependency "storytime/application_controller"

module Storytime
  class PostsController < ApplicationController
    before_action :ensure_site, unless: ->{ params[:controller] == "storytime/dashboard/sites" }
    def index
      @post_type = PostType.find_by(name: params[:post_type] || PostType::DEFAULT_TYPE_NAME)
      @posts = @post_type.posts
      @posts = @posts.tagged_with(params[:tag]) if params[:tag]
      @posts = @posts.published.order(created_at: :desc).page(params[:page]).per(10)

      respond_to do |format|
        format.atom
        format.html
      end
    end

    def show
      @post = if request.path == "/"
        Post.published.find @site.root_post_id 
      else
        Post.published.friendly.find(params[:id])
      end
      
      if params[:id] != @post.slug && request.path != "/"
        return redirect_to @post, :status => :moved_permanently
      end

      @comments = @post.comments

      #allow overriding in the host app
      render @post.slug if lookup_context.template_exists?("storytime/posts/#{@post.slug}")
      render @post.post_type.name if @post.post_type && lookup_context.template_exists?("storytime/posts/#{@post.post_type.name}")
    end
  end
end
