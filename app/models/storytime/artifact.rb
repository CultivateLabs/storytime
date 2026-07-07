module Storytime
  # A self-contained HTML artifact (CSS/JS/images inlined) served from a
  # private, unguessable token URL. Optionally gated by a password and/or an
  # expiration date. Content is stored in the database so access control can be
  # enforced on every request rather than relying on a public asset URL.
  class Artifact < ActiveRecord::Base
    include Storytime::ScopedToSite

    belongs_to :user, class_name: Storytime.user_class.to_s, optional: true
    belongs_to :site, optional: true

    # Optional password gate. `validations: false` keeps the password optional
    # while still giving us `password=` and `authenticate`.
    has_secure_password :password, validations: false

    before_validation :ensure_token, on: :create

    validates :name, presence: true
    validates :token, presence: true, uniqueness: true
    validates :content, presence: true

    scope :active, -> {
      where("storytime_artifacts.expires_at IS NULL OR storytime_artifacts.expires_at > ?", Time.current)
    }

    def to_param
      token
    end

    def expired?
      expires_at.present? && expires_at <= Time.current
    end

    def password_protected?
      password_digest.present?
    end

    # Accepts a raw string or an uploaded file (anything that responds to
    # #read) and stores it as the artifact's HTML content.
    def assign_html(io_or_string, filename: nil)
      data = io_or_string.respond_to?(:read) ? io_or_string.read : io_or_string
      data = data.to_s
      data = data.dup.force_encoding("UTF-8")
      self.content = data
      self.byte_size = data.bytesize
      self.content_type = "text/html"
      self.original_filename = filename if filename.present?
    end

  private

    def ensure_token
      return if token.present?

      self.token = loop do
        candidate = SecureRandom.urlsafe_base64(24)
        break candidate unless Storytime::Artifact.unscoped.exists?(token: candidate)
      end
    end
  end
end
