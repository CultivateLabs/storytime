class VideoPost < Storytime::Post
  include Storytime::CustomPostType
  
  def show_comments?
    true
  end

  def self.included_in_primary_feed?
    true
  end
end