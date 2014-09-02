require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class PostsController < DashboardController
      before_action :set_post, only: [:edit, :update, :destroy]
      before_action :load_posts
      before_action :load_media, only: [:new, :edit]
      
      respond_to :json, only: :destroy
      respond_to :html, only: :destroy

      def index
        authorize @posts
      end

      def new
        @post = new_post
        @post.category = current_category
        authorize @post
      end

      def edit
        authorize @post
      end

      def create
        @post = new_post(post_params)
        @post.draft_user_id = current_user.id
        authorize @post

        if @post.save
          redirect_to edit_dashboard_post_path(@post), notice: I18n.t('flash.posts.create.success')
        else
          load_media
          render :new
        end
      end

      def update
        authorize @post
        @post.draft_user_id = current_user.id
        if @post.update(post_params)
          redirect_to edit_dashboard_post_path(@post), notice: I18n.t('flash.posts.update.success')
        else
          load_media
          render :edit
        end
      end

      def destroy
        authorize @post
        @post.destroy
        flash[:notice] = I18n.t('flash.posts.destroy.success') unless request.xhr?
        respond_with [:dashboard, @post]
      end

    private

      def set_post
        @post = Post.friendly.find(params[:id])
      end

      def new_post(params)
        current_user.storytime_posts.new(params)
      end

      def base_posts_scope
        policy_scope(Storytime::Post).order(created_at: :desc).page(params[:page]).per(10)
      end

      def load_posts
        @posts = base_posts_scope
                
        @posts = if current_category
          @posts.where(category_id: current_category.id) 
        else
          @posts.primary_feed
        end
      end

      def post_params
        host_app_additions = respond_to?(:storytime_post_param_additions) ? storytime_post_param_additions : []
        permitted_attrs = policy(@post || current_user.storytime_posts.new).permitted_attributes.append *host_app_additions
        params.require(:post).permit(*permitted_attrs)
      end
    end
  end
end
