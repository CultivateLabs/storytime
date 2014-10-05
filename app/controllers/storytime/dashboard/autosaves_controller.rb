require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class AutosavesController < DashboardController
      before_action :set_post, only: [:create]

      skip_after_action :verify_authorized, only: [:create]

      respond_to :json

      def create
        if @post.autosave.nil? || (@post.autosave.content != params[:post][:draft_content])
          @post.create_autosave(autosave_params)
        end

        head :ok
      end

      private

        def set_post
          @post = Storytime::Post.friendly.find(params[:post_id])
        end

        def autosave_params
          post = @post || current_post_type.new(user: current_user)
          permitted_attrs = policy(post).permitted_attributes
          params.require(:post).permit(*permitted_attrs)
        end
    end
  end
end