module Storytime
  module Dashboard
    class BlogsController < PostsController
      respond_to :json

      def new
        @blog = current_post_type.new
        @blog.user = current_user
        authorize @blog
        respond_with @blog
      end

      def edit
        authorize @post
        @blog = @post
        respond_with @blog
      end

      def update
        authorize @post
        @blog = @post

        respond_with @blog do |format|
          if @blog.update_attributes(post_params)
            format.json { render :index }
          else
            format.json { render :edit, status: :unprocessable_entity }
          end
        end
      end

      def create
        @blog = current_post_type.new(post_params)
        @blog.user = current_user
        @blog.draft_content = "test"
        @blog.draft_user_id = current_user.id
        @blog.published_at = Time.now.utc
        authorize @blog

        respond_with @blog do |format|
          if @blog.save
            format.json { render :index }
          else
            format.json { render :new, status: :unprocessable_entity }
          end
        end
      end

      def destroy
        authorize @post
        @post.destroy
        flash[:notice] = I18n.t('flash.blogs.destroy.success') unless request.xhr?
        
        respond_with [:dashboard, @post] do |format|
          format.html{ redirect_to [:dashboard, Storytime::Page] }
        end
      end
      
    private
      def current_post_type
        @current_post_type ||= Storytime::Blog
      end
      helper_method :current_post_type
    end
  end
end