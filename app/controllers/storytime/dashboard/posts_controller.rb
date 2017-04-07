require_dependency "storytime/dashboard_controller"

module Storytime
  module Dashboard
    class PostsController < DashboardController
      before_action :hide_nav, only: [:new, :create, :edit, :update]
      before_action :set_post, only: [:edit, :update, :destroy]
      before_action :load_posts, only: :index
      before_action :sort_posts, only: :index
      before_action :load_media, only: [:new, :edit]

      respond_to :json, only: :destroy
      respond_to :html, only: :destroy

      set_tab :blog_posts

      def index
        authorize @posts
      end

      def new
        @post = new_post
        authorize @post
      end

      def edit
        authorize @post

        if params[:autosave]
          if @post.autosave
            @post.draft_content = @post.autosave.content
          else
            redirect_to [:edit, :dashboard, @post]
          end
        end
      end

      def create
        @post = new_post(post_params)
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

      def update
        authorize @post
        @post.draft_user_id = current_user.id

        if @post.update_attributes(post_params)
          @post.autosave.destroy unless @post.autosave.nil?

          send_subscriber_notifications if @post.published? && post_params[:notifications_enabled] == "1"

          redirect_to [:edit, :dashboard, @post], notice: I18n.t('flash.posts.update.success')
        else
          load_media
          render :edit
        end
      end

      def destroy
        authorize @post
        @post.destroy
        flash[:notice] = I18n.t('flash.posts.destroy.success') unless request.xhr?

        respond_with [:dashboard, @post] do |format|
          format.html{ redirect_to [:dashboard, current_post_type], type: @post.type_name }
        end
      end

    private
      def hide_nav
        @hide_nav = true
      end

      def load_posts
        @blog = Blog.friendly.find(params[:blog_id])
        @posts = @blog.posts.page(params[:page_number]).per(10)

        @posts = if params[:published].present? && params[:published] == "true"
          @posts.published
        elsif params[:draft].present? && params[:draft] == "true"
          @posts.draft
        else
          @posts
        end
      end

      def sort_posts
        @posts = if params[:sort].present?
          if params[:sort] == "title"
            @posts.order(title: :asc)
          elsif params[:sort] == "slug"
            @posts.order(slug: :asc)
          elsif params[:sort] == "published_at"
            @posts.order(published_at: :desc)
          elsif params[:sort] == "created_at"
            @posts.order(created_at: :desc)
          else
            @posts.order(published_at: :desc)
          end
        elsif params[:published] == "true"
          @posts.order(created_at: :desc)
        elsif params[:draft] == "true"
          @posts.order(updated_at: :desc)
        else
          @posts.order(published_at: :desc)
        end
      end

      def set_post
        @post = Storytime::Post.friendly.find(params[:id])
        @current_post_type = @post.type.constantize
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
        post = @post || current_post_type.new(user: current_user)
        permitted_attrs = policy(post).permitted_attributes
        permitted_attrs = permitted_attrs.append(storytime_post_param_additions) if respond_to?(:storytime_post_param_additions)
        params.require(current_post_type.type_name.tableize.singularize.to_sym).permit(*permitted_attrs)
      end

      def send_subscriber_notifications
        if Storytime.on_publish_with_notifications.nil?
          Storytime::PostNotifier.send_notifications_for(@post.id) if @post.published_at <= Time.now
        else
          Storytime.on_publish_with_notifications.call(@post)
        end
      end
    end
  end
end
