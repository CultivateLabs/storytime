module Storytime
  class Site < ActiveRecord::Base
    extend Storytime::Enum if Rails::VERSION::MINOR < 1

    enum post_slug_style: [:default, :day_and_name, :month_and_name, :post_id]
    enum root_page_content: [:posts, :page]

    validates :root_post_id, presence: true, if: ->(site){ site.root_page_content == "page" }
    validates :title, length: { in: 1..200 }

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
  end
end
