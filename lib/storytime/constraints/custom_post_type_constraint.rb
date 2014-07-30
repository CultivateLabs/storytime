module Storytime
  class CustomPostTypeConstraint
    def initialize
    end
   
    def matches?(request)
      Storytime::PostType.where(name: request.params[:post_type], permanent: false).any?
    end
  end
end