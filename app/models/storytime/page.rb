module Storytime
  class Page < Post
    def show_comments?
      false
    end

    def self.included_in_primary_feed?
      false
    end
  end
end