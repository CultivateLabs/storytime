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

        if params[:autosave]
          if @post.autosave
            @post.draft_content = @post.autosave.content
          else
            redirect_to url_for([:edit, :dashboard, @post])
          end
        end
      end

      def create
        @post = new_post(post_params)
        @post.draft_user_id = current_user.id
        authorize @post

        if @post.save
          @post.create_autosave(post_params.slice(:draft_content)) if params[:preview] == "true"

          publish if post_params['published'] == "1"

          opts = params[:preview] == "true" ? { preview: true } : {}

          redirect_to edit_dashboard_post_path(@post, opts), notice: I18n.t('flash.posts.create.success')
        else
          load_media
          render :new
        end
      end

      def update
        authorize @post
        @post.draft_user_id = current_user.id

        if @post.update(post_params)
          @post.autosave.destroy unless @post.autosave.nil?

          publish if post_params['published'] == "1"

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
          format.html{ redirect_to [:dashboard, Storytime::Post], type: @post.type_name }
        end
      end

    private

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
        params.require(:post).permit(*permitted_attrs)
      end

      def publish
        unless @post.published?
          @post.publish!

          if post_params[:send_subscriber_email] == "1"
            @site.active_email_subscriptions.each do |subscription|
              Storytime::SubscriptionMailer.new_post_email(@post, subscription).deliver
            end
          end
        end
      end

      def current_post_type
        @current_post_type ||= begin
          type_param = params[:type] || (params[:post] && params[:post].delete(:type))
          matching_type = Storytime.post_types.find{|post_type| post_type.constantize.type_name == type_param }
          matching_type.nil? ? Storytime::BlogPost : matching_type.constantize
        end
      end
      helper_method :current_post_type

      def load_posts
        @posts = policy_scope(Storytime::Post).order(created_at: :desc).page(params[:page_number]).per(10)
        
        @posts = if current_post_type.included_in_primary_feed?
          @posts.primary_feed
        else
          @posts.where(type: current_post_type)
        end

        @posts = if params[:published].present? && params[:published] == 'true'
          @posts.published
        else
          @posts.draft
        end
      end

      
    end
  end
end
