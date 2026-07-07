require "digest"

module Storytime
  # A named, revocable API credential. Only a SHA-256 digest of the token is
  # stored; the raw token is shown once at creation and never persisted. Each
  # token belongs to a user, so artifacts created via the API are attributed to
  # a real person.
  class ApiToken < ActiveRecord::Base
    include Storytime::ScopedToSite

    PREFIX = "sk_".freeze

    belongs_to :user, class_name: Storytime.user_class.to_s, optional: true
    belongs_to :site, optional: true

    validates :name, presence: true
    validates :token_digest, presence: true, uniqueness: true

    # Holds the raw token immediately after generation so it can be displayed
    # once. Never populated when loading an existing record.
    attr_reader :raw_token

    before_validation :generate_token, on: :create

    scope :active, -> {
      where("storytime_api_tokens.expires_at IS NULL OR storytime_api_tokens.expires_at > ?", Time.current)
    }

    def self.digest(raw)
      ::Digest::SHA256.hexdigest(raw.to_s)
    end

    # Returns the matching active token for a raw bearer token, or nil.
    # Not site-scoped: tokens are globally unique by digest.
    def self.authenticate(raw)
      return if raw.blank?

      unscoped.active.find_by(token_digest: digest(raw))
    end

    def expired?
      expires_at.present? && expires_at <= Time.current
    end

    def touch_last_used!
      update_column(:last_used_at, Time.current)
    end

  private

    def generate_token
      return if token_digest.present?

      @raw_token = loop do
        candidate = PREFIX + SecureRandom.alphanumeric(40)
        break candidate unless Storytime::ApiToken.unscoped.exists?(token_digest: self.class.digest(candidate))
      end

      self.token_digest = self.class.digest(@raw_token)
      self.token_prefix = @raw_token[0, 11]
    end
  end
end
