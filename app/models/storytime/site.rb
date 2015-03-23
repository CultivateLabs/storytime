module Storytime
  class Site < ActiveRecord::Base
    require 'uri'
    extend Storytime::Enum if Rails::VERSION::MINOR < 1

    enum post_slug_style: [:default, :day_and_name, :month_and_name, :post_id]
    enum root_page_content: [:posts, :page]

    has_many :memberships, class_name: "Storytime::Membership", dependent: :destroy
    has_many :users, through: :memberships, class_name: Storytime.user_class
    has_many :subscriptions, dependent: :destroy
    has_many :posts, dependent: :destroy
    has_many :blog_posts, dependent: :destroy
    has_many :pages, dependent: :destroy
    has_many :blogs, dependent: :destroy
    belongs_to :homepage, class_name: "Storytime::Post", foreign_key: "root_post_id"
    belongs_to :creator, class_name: Storytime.user_class, foreign_key: "user_id"

    validates :subscription_email_from, presence: true
    validates :custom_domain, presence: true, uniqueness: true
    validates :title, presence: true, length: { in: 1..200 }

    before_save :remove_http_from_custom_domain

    def self.current_id=(id)
      Thread.current[:storytime_site_id] = id
    end

    def self.current_id
      Thread.current[:storytime_site_id]
    end

    def self.current
      find(current_id)
    end

    def save_with_seeds(user)
      self.creator = user
      if save
        self.class.setup_seeds
        Storytime::Membership.create(user: user, site: self, storytime_role: Storytime::Role.find_by(name: "admin"))
        blog = Storytime::Blog.seed(self, user)
        self.update_column("root_post_id", blog.id)
      else
        false
      end
    end

    def self.setup_seeds
      Storytime::Role.seed
      Storytime::Action.seed
      Storytime::Permission.seed
    end

    def root_post_options
      Storytime::Post.published.where(type: ["Storytime::Page", "Storytime::Blog"])
    end

    def active_email_subscriptions
      subscriptions.active
    end

    def custom_view_path
      self.title.parameterize
    end

  private
    def remove_http_from_custom_domain
      self.custom_domain = self.custom_domain.gsub(/http:\/\/|https:\/\//, "")
    end
  end
end
