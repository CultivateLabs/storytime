module Storytime
  class Site < ActiveRecord::Base
    enum post_slug_style: [:default, :day_and_name, :month_and_name, :post_name]
    enum root_page_content: [:posts, :page]

    validates :root_post_id, presence: true, if: ->(site){ site.root_page_content == "page" }
    validates :title, length: { in: 1..200 }

    def save_with_seeds(user)
      setup_seeds
      user.update_attributes(storytime_role: Storytime::Role.find_by(name: "admin"))
      save
    end

    def setup_seeds
      Storytime::PostType.seed
      Storytime::Role.seed
      Storytime::Action.seed
      Storytime::Permission.seed
    end

    def root_post_options
      Storytime::PostType.static_page_type.posts.published
    end
  end
end
