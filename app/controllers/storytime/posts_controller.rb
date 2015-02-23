require_dependency "storytime/application_controller"

module Storytime
  class PostsController < ApplicationController

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
      
      content_for :title, "#{@site.title} | #{@post.title}"
      
      if params[:preview].nil? && ((@site.post_slug_style != "post_id") && (params[:id] != @post.slug))
        return redirect_to @post, :status => :moved_permanently
      end

      @comments = @post.comments.order("created_at DESC")
      #allow overriding in the host app

      if lookup_context.template_exists?("storytime/#{@site.subdomain}/#{@post.type_name.pluralize}/#{@post.slug}")
        render "storytime/#{@site.subdomain}/#{@post.type_name.pluralize}/#{@post.slug}"
      elsif lookup_context.template_exists?("storytime/#{@site.subdomain}/#{@post.type_name.pluralize}/show")
        render "storytime/#{@site.subdomain}/#{@post.type_name.pluralize}/show"
      end
    end
  end
end
