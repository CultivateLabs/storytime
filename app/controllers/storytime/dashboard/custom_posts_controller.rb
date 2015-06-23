module Storytime
  module Dashboard
    class CustomPostsController < BlogPostsController

    def new
      @post = current_post_type.new
      @post.blog = Storytime::Blog.friendly.find(params[:blog_id])
      @post.user = current_user
      authorize @post
    end

    def create
      @post = current_post_type.new(post_params)
      @post.blog = Storytime::Blog.friendly.find(params[:blog_id])
      @post.user = current_user
      @post.draft_user_id = current_user.id

      authorize @post

      if @post.save
        @post.create_autosave(post_params.slice(:draft_content)) if params[:preview] == "true"

        send_subscriber_notifications if @post.published? && post_params[:notifications_enabled] == "1"

        opts = params[:preview] == "true" ? { preview: true } : {}

        redirect_to [:edit, :dashboard, @post, opts], notice: I18n.t('flash.posts.create.success')
      else
        load_media
        render :new
      end
    end
      
    private
      def current_post_type
        @current_post_type ||= params[:post_type].classify.constantize
      end
      helper_method :current_post_type

      def load_posts
        @posts = policy_scope(Storytime::Post).page(params[:page_number]).per(10).where(type: current_post_type)
        
        @posts = if params[:published].present? && params[:published] == 'true'
          @posts.published.order(published_at: :desc)
        else
          @posts.draft.order(updated_at: :desc)
        end
      end
    end
  end
end