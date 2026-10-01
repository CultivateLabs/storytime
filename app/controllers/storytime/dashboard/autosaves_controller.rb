require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class AutosavesController < DashboardController
      before_action :set_post, only: [:create]

      respond_to :json

      def create
        authorize @post, :update?

        @post.with_lock do
          autosave = @post.autosave || @post.build_autosave
          if autosave.update(autosave_params)
            head :ok
          else
            render json: { errors: autosave.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end

      private

        def set_post
          @post = Storytime::Post.friendly.find(params["#{post_type_name}_id".to_sym])
        end

        def post_type_name
          @post_type_name = request.path.split("/")[2].singularize
        end

        def autosave_params
          params.require(post_type_name.to_sym).permit(:draft_content)
        end
    end
  end
end