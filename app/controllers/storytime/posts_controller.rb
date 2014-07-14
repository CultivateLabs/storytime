require_dependency "storytime/application_controller"

module Storytime
  class PostsController < ApplicationController
    before_action :ensure_site, unless: ->{ params[:controller] == "storytime/dashboard/sites" }
    def index
      @posts = if params[:tag]
        Post.tagged_with(params[:tag])
      else
        Post.all
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
