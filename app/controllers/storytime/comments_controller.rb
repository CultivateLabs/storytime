require_dependency "storytime/application_controller"

module Storytime
  class CommentsController < ApplicationController
    before_action :authenticate_user!
    after_action :verify_authorized

    before_action :set_post, only: :create

    respond_to :json, only: :destroy

    def create
      @comment = current_user.storytime_comments.new(comment_params)
      @comment.post = @post
      authorize @comment
      opts = { notice: I18n.t('flash.comments.create.success') } if @comment.save
      redirect_to @post, opts
    end

    def destroy
      @comment = current_user.storytime_comments.find(params[:id])
      authorize @comment
      @comment.destroy
      respond_with @comment
    end

  private

    def set_post
      @post = Post.friendly.find(params[:post_id])
    end

    def comment_params
      params.require(:comment).permit(*policy(@comment || current_user.storytime_comments.new).permitted_attributes)
    end

  end
end
