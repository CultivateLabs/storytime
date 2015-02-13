class VideoPost < Storytime::Post
  include Storytime::BlogPostPartialInheritance
  
  def show_comments?
    true
  end

  def self.included_in_primary_feed?
    true
  end
end