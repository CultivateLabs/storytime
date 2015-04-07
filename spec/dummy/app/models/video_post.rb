class VideoPost < Storytime::BlogPost
  def show_comments?
    true
  end

  def self.included_in_primary_feed?
    false
  end
end