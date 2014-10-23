require_dependency "storytime/application_controller"

module Storytime
  class PostsController < ApplicationController
    before_action :ensure_site, unless: ->{ params[:controller] == "storytime/dashboard/sites" }

    def index
      @posts = if params[:post_type]
        klass = Storytime.post_types.find{|post_type| post_type.constantize.type_name == params[:post_type].singularize }
        klass.constantize.all
      else
        Post.primary_feed
      end
      
      @posts = @posts.tagged_with(params[:tag]) if params[:tag]
      @posts = @posts.published.order(published_at: :desc).page(params[:page])
      
      respond_to do |format|
        format.atom
        format.html
      end
    end

    def show
      @post = if params[:preview]
        post = Post.find_preview(params[:id])
        post.content = post.autosave.content
        post.preview = true
        post
      else
        Post.published.friendly.find(params[:id])
      end

      authorize @post
      
      if params[:preview].nil? && ((@site.post_slug_style != "post_id") && (params[:id] != @post.slug))
        return redirect_to @post, :status => :moved_permanently
      end

      @comments = @post.comments.order("created_at DESC")
      #allow overriding in the host app
      if lookup_context.template_exists?("storytime/posts/#{@post.slug}")
        render @post.slug 
      elsif lookup_context.template_exists?("storytime/#{@post.type_name.pluralize}/show")
        render "storytime/#{@post.type_name.pluralize}/show"
      end
    end

  end
end
