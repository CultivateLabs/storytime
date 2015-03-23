module Storytime::PostExcerpt
  extend ActiveSupport::Concern

  included do
    validates :excerpt, length: { in: 0..Storytime.post_excerpt_character_limit }

    before_validation :populate_excerpt_from_content

    def populate_excerpt_from_content
      self.excerpt = (content || draft_content).slice(0..Storytime.post_excerpt_character_limit) if excerpt.blank?
      self.excerpt = strip_tags(self.excerpt)
    end
  end
end