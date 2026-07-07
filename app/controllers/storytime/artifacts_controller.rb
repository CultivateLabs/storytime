require "digest"
require_dependency "storytime/application_controller"

module Storytime
  # Public, token-addressed serving of artifacts. No dashboard auth: access is
  # controlled by the unguessable token, an optional password gate (remembered
  # per-artifact in the session), and an optional expiration date.
  #
  # The artifact HTML is never rendered on the app's own origin. `#show` returns
  # a trusted wrapper page that embeds the content (served by `#raw`) in a
  # sandboxed iframe, so the artifact's scripts run in an opaque origin and
  # cannot reach the app's cookies, DOM, or authenticated same-origin requests.
  class ArtifactsController < ApplicationController
    layout false

    # Capabilities granted to the artifact iframe, applied both as the iframe's
    # `sandbox` attribute and as a matching `Content-Security-Policy: sandbox`
    # on the raw response (so a direct hit is sandboxed identically).
    # Deliberately WITHOUT `allow-same-origin` (that, combined with
    # `allow-scripts`, would let the frame drop its own sandbox) and without
    # `allow-top-navigation` (so an artifact can't redirect the parent page).
    SANDBOX_TOKENS = "allow-scripts allow-popups allow-popups-to-escape-sandbox " \
                     "allow-forms allow-downloads allow-modals".freeze

    # Brute-force guard for the password gate: at most this many failed unlock
    # attempts per artifact+IP within the rolling window before we stop checking.
    MAX_UNLOCK_ATTEMPTS = 10
    UNLOCK_WINDOW = 15.minutes

    # Cap how many artifact unlocks we remember per session. Unlocks live in the
    # cookie session store (~4KB), so an unbounded hash could overflow it and
    # break requests; keep only the most recently unlocked artifacts.
    MAX_REMEMBERED_UNLOCKS = 20

    before_action :load_artifact

    def show
      return render_password_form if locked?

      set_noindex_headers
      @sandbox_tokens = SANDBOX_TOKENS
      render "storytime/artifacts/show"
    end

    # The sandboxed artifact document itself, embedded by #show's iframe. Gated
    # identically to #show so the content can't be fetched while still locked.
    def raw
      return not_found if locked?

      deliver_artifact
    end

    def unlock
      if unlock_throttled?
        flash.now[:artifact_error] = "Too many attempts. Please wait a few minutes and try again."
        return render_password_form(status: :too_many_requests)
      end

      if @artifact.password_protected? && @artifact.authenticate(params[:password].to_s)
        clear_unlock_attempts
        remember_unlock
        redirect_to artifact_path(@artifact.token)
      else
        register_unlock_attempt
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
      # Sandbox the response itself, so even a direct navigation to the raw URL
      # renders in an opaque origin rather than the app's.
      response.set_header("Content-Security-Policy", "sandbox #{SANDBOX_TOKENS}")
      send_data @artifact.content,
                type: "text/html; charset=utf-8",
                disposition: "inline"
    end

    def locked?
      @artifact.password_protected? && !unlocked?
    end

    def render_password_form(status: :ok)
      set_noindex_headers
      render "storytime/artifacts/password", status: status
    end

    def set_noindex_headers
      response.set_header("X-Robots-Tag", "noindex, nofollow, noarchive")
      # Artifacts are served with an explicit text/html type; stop browsers from
      # MIME-sniffing the stored content into some other executable type.
      response.set_header("X-Content-Type-Options", "nosniff")
    end

    def unlock_throttled?
      Rails.cache.read(unlock_attempts_key).to_i >= MAX_UNLOCK_ATTEMPTS
    end

    def register_unlock_attempt
      count = Rails.cache.read(unlock_attempts_key).to_i + 1
      Rails.cache.write(unlock_attempts_key, count, expires_in: UNLOCK_WINDOW)
    end

    def clear_unlock_attempts
      Rails.cache.delete(unlock_attempts_key)
    end

    def unlock_attempts_key
      "storytime:artifact_unlock:#{@artifact.token}:#{request.remote_ip}"
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

    # Record the current artifact as unlocked, keeping the stored set bounded.
    # Re-inserting moves this token to the most-recent position, and we drop the
    # oldest entries beyond MAX_REMEMBERED_UNLOCKS so the session cookie can't
    # grow without bound.
    def remember_unlock
      tokens = unlocked_tokens
      tokens.delete(@artifact.token)
      tokens[@artifact.token] = unlock_fingerprint
      if tokens.size > MAX_REMEMBERED_UNLOCKS
        tokens.keys.first(tokens.size - MAX_REMEMBERED_UNLOCKS).each { |k| tokens.delete(k) }
      end
    end

    def not_found
      raise ActionController::RoutingError, "Artifact not found"
    end
  end
end
