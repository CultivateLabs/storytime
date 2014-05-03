require_dependency "storytime/application_controller"

module Storytime
  class PostsController < ApplicationController
    before_action :set_post, only: [:show]

    # GET /posts
    def index
      @posts = Post.all.page(params[:page]).per(10)
    end

    # GET /posts/1
    def show
    end

    private
    
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end
  end
end
