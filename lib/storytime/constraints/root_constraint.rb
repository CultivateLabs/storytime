module Storytime
  class RootConstraint
    def initialize(root_page)
      @root_page = root_page
    end
   
    def matches?(request)
      Storytime::Site.first && Storytime::Site.first.root_page_content == @root_page
    end
  end
end