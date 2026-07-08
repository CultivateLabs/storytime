require_dependency "storytime/application_controller"

module Storytime
  class DashboardController < ::Storytime::ApplicationController
    before_action :authenticate_user!
    before_action :verify_storytime_user, unless: ->{ Storytime::Site.count == 0 }
    layout "storytime/dashboard"

    after_action :verify_authorized, unless: :admin_controller?

  private

    def verify_storytime_user
      raise Pundit::NotAuthorizedError if current_user.storytime_memberships.count == 0
    end

    def load_media
      @media = Media.order("created_at DESC").page(1).per(10)
      @large_gallery = false
    end

    def dashboard_controller
      true
    end

    def admin_controller?
      false
    end

    # Parses a datepicker value (e.g. "July 8, 2026") into an end-of-day time,
    # or nil when blank/unparseable (meaning "no expiration").
    def parse_expiration(value)
      return nil if value.blank?
      # Time.zone.parse returns nil for strings with no date tokens and raises
      # ArgumentError for out-of-range dates; guard against both.
      parsed = Time.zone.parse(value.to_s)
      parsed&.end_of_day
    rescue ArgumentError
      nil
    end
  end
end
