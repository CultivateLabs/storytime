module Storytime
  class Page < Post
    def show_comments?
      false
    end
  end
end