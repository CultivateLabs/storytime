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
          redirect_to url_for([:edit, :dashboard, @post]), notice: I18n.t('flash.posts.create.success')
        else
          load_media
          render :new
        end
      end

      def update
        authorize @post
        @post.draft_user_id = current_user.id
        if @post.update(post_params)
          redirect_to url_for([:edit, :dashboard, @post]), notice: I18n.t('flash.posts.update.success')
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
        @post = current_post_type.friendly.find(params[:id])
      end

      def new_post(attrs = nil)
        post = if params[:action] == "new"
          current_post_type.new
        else
          current_post_type.new(attrs)
        end

        post.user = current_user
        post
      end

      def post_params
        permitted_attrs = policy(@post || current_post_type.new(user: current_user)).permitted_attributes
        permitted_attrs = permitted_attrs.append(storytime_post_param_additions) if respond_to?(:storytime_post_param_additions)
        params.require(current_post_type.type_name.to_sym).permit(*permitted_attrs)
      end

      def current_post_type
        raise "current_post_type method should be overridden by subclasses"
      end
      helper_method :current_post_type

      def load_posts
        @posts = policy_scope(current_post_type).where(type: current_post_type).order(created_at: :desc).page(params[:page_number]).per(10)
      end

      
    end
  end
end
