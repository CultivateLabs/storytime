module Storytime
  class Site < ActiveRecord::Base
    require 'uri'

    enum :post_slug_style, [:default, :day_and_name, :month_and_name, :post_id]

    has_many :memberships, class_name: "Storytime::Membership", dependent: :destroy
    has_many :users, through: :memberships, class_name: Storytime.user_class.to_s
    has_many :subscriptions, dependent: :destroy
    has_many :posts, dependent: :destroy
    has_many :blog_posts, dependent: :destroy
    has_many :pages, -> { where(type: "Storytime::Page") }, dependent: :destroy
    has_many :blogs, dependent: :destroy
    has_many :navigations, dependent: :destroy
    has_one :homepage, class_name: "Storytime::Post", foreign_key: "id", primary_key: "root_post_id", required: false
    belongs_to :creator, class_name: Storytime.user_class.to_s, foreign_key: "user_id"

    validates :subscription_email_from, presence: true
    validates :custom_domain, presence: true, uniqueness: true
    validates :title, presence: true, length: { in: 1..200 }

    validate :homepage_belongs_to_site, if: :root_post_id_changed?

    before_validation :remove_http_from_custom_domain

    def self.current_id=(id)
      Thread.current[:storytime_site_id] = id
    end

    def self.current_id
      Thread.current[:storytime_site_id]
    end

    def self.current
      find(current_id) if current_id
    end

    def save_with_seeds(user)
      previous_site_id = self.class.current_id
      self.creator = user
      self.class.transaction do
        next false unless save

        self.class.current_id = id
        self.class.setup_seeds(self)
        Storytime::Membership.find_or_create_by!(user: user, site: self) do |membership|
          membership.storytime_role = Storytime::Role.find_by!(name: "admin")
        end
        blog = Storytime::Blog.seed(self, user)
        raise ActiveRecord::RecordInvalid, blog unless blog.persisted?

        update!(root_post_id: blog.id)
      end
    ensure
      self.class.current_id = previous_site_id
    end

    def self.setup_seeds(site = nil)
      Storytime::Role.seed
      Storytime::Action.seed
      Storytime::Permission.seed(site ? [site] : Storytime::Site.all)
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
    def homepage_belongs_to_site
      return if root_post_id.blank?
      return if posts.published.where(type: ["Storytime::Page", "Storytime::Blog"]).exists?(id: root_post_id)

      errors.add(:root_post_id, "must be a published page or blog belonging to this site")
    end

    def remove_http_from_custom_domain
      self.custom_domain = custom_domain.to_s.gsub(/\Ahttps?:\/\//, "")
    end
  end
end
