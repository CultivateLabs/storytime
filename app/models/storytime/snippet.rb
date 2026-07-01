module Storytime
  class Snippet < ActiveRecord::Base
    include Storytime::ScopedToSite
    belongs_to :site

    validates :name, length: { in: 1..255 }
    validates :content, length: { in: 1..20000 }

    before_save :sanitize_content

    # Snippet content is rendered with `raw` in the front-end (see
    # app/views/storytime/snippets/_snippet.html.erb), so it must be scrubbed
    # on write with the same allow-list used for Post/Page content. Otherwise
    # an editor could store arbitrary HTML/JS (stored XSS).
    def sanitize_content
      return if Storytime.post_sanitizer.blank? || content.blank?
      self.content = Storytime.post_sanitizer.call(content)
    end
  end
end
