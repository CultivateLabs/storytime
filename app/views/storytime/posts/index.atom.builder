atom_feed do |feed|
  feed.title @current_storytime_site.title
  feed.updated @posts.maximum(:updated_at)
  
  @posts.each do |post|
    feed.entry post, published: post.published_at do |entry|
      entry.title post.title
      entry.content post.content
      entry.author do |author|
        author.name post.author_name
      end
    end
  end
end