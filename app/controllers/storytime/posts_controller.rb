require_dependency "storytime/application_controller"

module Storytime
  class PostsController < ApplicationController
    def index
      @posts = Post.all.page(params[:page]).per(10)
    end

    def show
      @post = Post.find(params[:id])
    end
  end
end
