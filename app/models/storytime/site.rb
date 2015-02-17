module Storytime
  class Site < ActiveRecord::Base
    extend Storytime::Enum if Rails::VERSION::MINOR < 1

    enum post_slug_style: [:default, :day_and_name, :month_and_name, :post_id]
    enum root_page_content: [:posts, :page]

    has_many :subscriptions, dependent: :destroy
    has_many :posts, dependent: :destroy
    has_many :blog_posts, dependent: :destroy
    has_many :pages, dependent: :destroy

    validates :subdomain, presence: true, uniqueness: true
    validates :root_post_id, presence: true, if: ->(site){ site.root_page_content == "page" }
    validates :title, presence: true, length: { in: 1..200 }

    before_create :parameterize_subdomain
    after_create :ensure_routes_updated
    after_update :ensure_routes_updated

    def self.current_id=(id)
      Thread.current[:site_id] = id
    end

    def self.current_id
      Thread.current[:site_id]
    end

    def ensure_routes_updated
      if id_changed? || root_post_id_changed? || post_slug_style_changed? || root_page_content_changed?
        Rails.application.reload_routes!
      end
    end

    def save_with_seeds(user)
      self.class.setup_seeds
      user.update_attributes(storytime_role: Storytime::Role.find_by(name: "admin"))
      save
    end

    def self.setup_seeds
      Storytime::Role.seed
      Storytime::Action.seed
      Storytime::Permission.seed
    end

    def root_post_options
      Storytime::Page.published
    end

    def active_email_subscriptions
      subscriptions.active
    end

  private
    def parameterize_subdomain
      self.subdomain = self.subdomain.parameterize
    end
  end
end
