require "digest"
require_dependency "storytime/application_controller"

module Storytime
  # Public, token-addressed serving of artifacts. No dashboard auth: access is
  # controlled by the unguessable token, an optional password gate (remembered
  # per-artifact in the session), and an optional expiration date.
  class ArtifactsController < ApplicationController
    layout false

    before_action :load_artifact

    def show
      return render_password_form if @artifact.password_protected? && !unlocked?

      deliver_artifact
    end

    def unlock
      if @artifact.password_protected? && @artifact.authenticate(params[:password].to_s)
        unlocked_tokens[@artifact.token] = unlock_fingerprint
        redirect_to artifact_path(@artifact.token)
      else
        flash.now[:artifact_error] = "Incorrect password. Please try again."
        render_password_form(status: :unauthorized)
      end
    end

  private

    def load_artifact
      # Scoped to the current site via ScopedToSite; tokens are globally unique.
      @artifact = Storytime::Artifact.find_by(token: params[:token])
      not_found if @artifact.nil? || @artifact.expired?
    end

    def deliver_artifact
      set_noindex_headers
      send_data @artifact.content,
                type: "text/html; charset=utf-8",
                disposition: "inline"
    end

    def render_password_form(status: :ok)
      set_noindex_headers
      render "storytime/artifacts/password", status: status
    end

    def set_noindex_headers
      response.set_header("X-Robots-Tag", "noindex, nofollow, noarchive")
    end

    def unlocked?
      unlocked_tokens[@artifact.token] == unlock_fingerprint
    end

    # Ties a session unlock to the current password. Rotating, removing, or
    # re-adding the password changes the digest, so any earlier unlock stored in
    # the session no longer matches and the visitor must re-enter the password.
    def unlock_fingerprint
      Digest::SHA256.hexdigest(@artifact.password_digest.to_s)
    end

    def unlocked_tokens
      session[:storytime_unlocked_artifacts] ||= {}
    end

    def not_found
      raise ActionController::RoutingError, "Artifact not found"
    end
  end
end
