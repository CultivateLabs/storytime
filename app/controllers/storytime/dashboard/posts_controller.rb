require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class PostsController < DashboardController
      before_action :set_post, only: [:edit, :update, :destroy]
      before_action :load_media, only: [:new, :edit]
      
      respond_to :json, only: [:destroy]

      def index
        @posts = Post.all.page(params[:page]).per(10)
        authorize @posts
      end

      def new
        @post = current_user.posts.new
        authorize @post
      end

      def edit
        authorize @post
      end

      def create
        @post = current_user.posts.new(post_params)
        @post.draft_user_id = current_user.id
        authorize @post

        if @post.save
          redirect_to dashboard_posts_path, notice: I18n.t('flash.posts.create.success')
        else
          render :new
        end
      end

      def update
        authorize @post
        @post.draft_user_id = current_user.id
        if @post.update(post_params)
          redirect_to dashboard_posts_path, notice: I18n.t('flash.posts.update.success')
        else
          render :edit
        end
      end

      def destroy
        authorize @post
        @post.destroy
        respond_with @post
      end

      private
        def set_post
          @post = Post.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def post_params
          params.require(:post).permit(:title, :draft_content, :excerpt, :published, :post_type, :tag_list)
        end
    end
  end
end
