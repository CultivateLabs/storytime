require_dependency "storytime/application_controller"

module Storytime
  module Api
    module V1
      # Token-authenticated JSON API for creating/replacing/deleting artifacts
      # programmatically. Authenticate with `Authorization: Bearer <token>`
      # where the token matches Storytime.artifacts_api_token.
      class ArtifactsController < ::Storytime::ApplicationController
        layout false
        protect_from_forgery with: :null_session
        skip_before_action :verify_authenticity_token, raise: false

        before_action :authenticate_api_token!
        before_action :load_artifact, only: [:show, :update, :destroy]

        def index
          artifacts = Storytime::Artifact.order("created_at DESC")
          render json: artifacts.map { |a| artifact_json(a) }
        end

        def show
          render json: artifact_json(@artifact)
        end

        def create
          artifact = Storytime::Artifact.new(name: params[:name])
          artifact.site = current_storytime_site
          artifact.user = api_user
          assign_content(artifact)
          assign_options(artifact)

          if artifact.save
            render json: artifact_json(artifact), status: :created
          else
            render json: { errors: artifact.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          @artifact.name = params[:name] if params.key?(:name)
          assign_content(@artifact)
          assign_options(@artifact)

          if @artifact.save
            render json: artifact_json(@artifact)
          else
            render json: { errors: @artifact.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @artifact.destroy
          head :no_content
        end

      private

        def load_artifact
          @artifact = Storytime::Artifact.find_by(token: params[:token])
          head :not_found if @artifact.nil?
        end

        def assign_content(artifact)
          if params[:file].respond_to?(:read)
            artifact.assign_html(params[:file], filename: params[:file].try(:original_filename))
          elsif params[:html].present?
            artifact.assign_html(params[:html], filename: params[:filename])
          end
        end

        def assign_options(artifact)
          artifact.password = params[:password].presence if params.key?(:password)
          artifact.expires_at = params[:expires_at].presence if params.key?(:expires_at)
        end

        def artifact_json(a)
          {
            token: a.token,
            name: a.name,
            url: artifact_url(a.token),
            password_protected: a.password_protected?,
            expires_at: a.expires_at,
            byte_size: a.byte_size,
            created_at: a.created_at,
            updated_at: a.updated_at
          }
        end

        def authenticate_api_token!
          configured = Storytime.artifacts_api_token.to_s
          provided = bearer_token.to_s

          if configured.blank? || provided.blank? || !secure_match?(provided, configured)
            render json: { error: "Unauthorized" }, status: :unauthorized
          end
        end

        def secure_match?(a, b)
          ActiveSupport::SecurityUtils.secure_compare(
            ::Digest::SHA256.hexdigest(a),
            ::Digest::SHA256.hexdigest(b)
          )
        end

        def bearer_token
          request.authorization.to_s[/\ABearer\s+(.+)\z/i, 1] || params[:api_token]
        end

        def api_user
          current_storytime_site.try(:creator) || Storytime.user_class.first
        end
      end
    end
  end
end
