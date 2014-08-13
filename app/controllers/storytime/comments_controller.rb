require_dependency "storytime/application_controller"

module Storytime
  class CommentsController < ApplicationController
    before_action :authenticate_user!
    after_action :verify_authorized

    before_action :set_post

    def create
      @comment = @post.comments.new(comment_params)
      @comment.user = current_user
      authorize @comment
      opts = { notice: I18n.t('flash.comments.create.success') } if @comment.save
      redirect_to @post, opts
    end

  private

    def set_post
      @post = Post.find(params[:comment].delete(:post_id))
    end

    def comment_params
      params.require(:comment).permit(*policy(@comment || @post.comments.new).permitted_attributes)
    end

  end
end
