module Storytime
  class BlogPost < Post
    include Storytime::PostComments
    include Storytime::PostExcerpt
    include Storytime::PostFeaturedImages
    belongs_to :blog

    def to_param
      case site.post_slug_style
      when "default"
        "posts/#{slug}"
      when "day_and_name" 
        date = created_at.to_date
        "#{date.strftime("%Y")}/#{date.strftime("%m")}/#{date.strftime("%d")}/#{slug}"
      when "month_and_name"
        date = created_at.to_date
        "#{date.strftime("%Y")}/#{date.strftime("%m")}/#{slug}"
      when "post_id"
        "posts/#{id}"
      end
    end
  end
end