require_dependency "storytime/application_controller"

module Storytime
  class PostsController < ApplicationController
    before_action :ensure_site, unless: ->{ params[:controller] == "storytime/dashboard/sites" }
    def index
      @posts = if params[:tag]
        Post.tagged_with(params[:tag])
      elsif params[:post_type]
        PostType.find_by(name: params[:post_type]).posts
      else
        Post.where(post_type_id: nil)
      end
      @posts = @posts.published.order(created_at: :desc).page(params[:page]).per(10)

      respond_to do |format|
        format.atom
        format.html
      end
    end

    def show
      @post = Post.published.find(params[:id])
    end
  end
end
