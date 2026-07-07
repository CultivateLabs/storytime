require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class ArtifactsController < DashboardController
      before_action :load_artifact, only: [:edit, :update, :destroy]

      def index
        @artifacts = Storytime::Artifact.order("created_at DESC").page(params[:page]).per(20)
        authorize @artifacts
      end

      def new
        @artifact = Storytime::Artifact.new
        authorize @artifact
      end

      def create
        @artifact = Storytime::Artifact.new(name: artifact_params[:name])
        @artifact.user = current_user
        @artifact.site = current_storytime_site
        apply_form_attributes(@artifact)
        authorize @artifact

        if @artifact.save
          redirect_to [:dashboard, :artifacts], notice: "Artifact created."
        else
          render :new
        end
      end

      def edit
        authorize @artifact
      end

      def update
        authorize @artifact
        @artifact.name = artifact_params[:name] if artifact_params.key?(:name)
        apply_form_attributes(@artifact)

        if @artifact.save
          redirect_to [:dashboard, :artifacts], notice: "Artifact updated."
        else
          render :edit
        end
      end

      def destroy
        authorize @artifact
        @artifact.destroy
        redirect_to [:dashboard, :artifacts], notice: "Artifact deleted."
      end

    private

      def load_artifact
        @artifact = Storytime::Artifact.find_by!(token: params[:id])
      end

      def apply_form_attributes(artifact)
        file = artifact_params[:file]
        artifact.assign_html(file, filename: file.original_filename) if file.present?

        if artifact_params[:remove_password] == "1"
          artifact.password = nil
        elsif artifact_params[:password].present?
          artifact.password = artifact_params[:password]
        end

        artifact.expires_at = artifact_params[:expires_at].presence if artifact_params.key?(:expires_at)
      end

      def artifact_params
        params.require(:artifact).permit(:name, :file, :password, :remove_password, :expires_at)
      end
    end
  end
end
