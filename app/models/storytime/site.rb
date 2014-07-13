module Storytime
  class Site < ActiveRecord::Base
    enum post_slug_style: [:default, :day_and_name, :month_and_name, :post_name]
    enum root_page_content: [:posts, :page]

    validates :selected_root_page_id, presence: true, if: ->(site){ site.root_page_content == "page" }
    validates :title, length: { in: 1..200 }

    def save_with_seeds(user)
      Storytime::Role.seed
      Storytime::Action.seed
      Storytime::Permission.seed
      current_user.update_attributes(storytime_role: Storytime::Role.find_by(name: "admin"))
      save
    end
  end
end
