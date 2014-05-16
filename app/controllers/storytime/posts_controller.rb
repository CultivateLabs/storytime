require_dependency "storytime/application_controller"

module Storytime
  class PostsController < ApplicationController
    def index
      @posts = if params[:tag]
        Post.tagged_with(params[:tag])
      else
        Post.all
      end
      @posts = @posts.where(published: true).order(created_at: :desc).page(params[:page]).per(10)
    end

    def show
      @post = Post.where(published: true).find(params[:id])
    end
  end
end
