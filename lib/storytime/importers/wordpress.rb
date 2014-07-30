module Storytime
  module Importers
    class Wordpress < Importer
      attr_accessor :xml

      def import!
        self.xml = Nokogiri::XML(file_content)
        posts = []
        post_type = Storytime::PostType.find_by(name: 'blog')

        self.xml.xpath("//item").each do |item|
          if item.xpath(".//wp:post_type[contains(., 'post')]").length > 0
            post = Storytime::Post.new
            post.title = item.xpath("title").text
            post.user = creator
            post.content = item.xpath("content:encoded").text
            post.draft_content = post.content
            post.post_type = post_type
            
            date = item.xpath("wp:post_date_gmt").text
            if date && !date.blank? && date != "0000-00-00 00:00:00"
              post.created_at = Time.strptime(date+" UTC", "%Y-%m-%d %H:%M:%S %Z")
            end

            if item.xpath("wp:status").text == "publish"
              pub_date = item.xpath("pubDate").text
              if pub_date && !pub_date.blank?
                post.published_at = Time.strptime(pub_date, "%a, %d %b %Y %H:%M:%S %z")
              end
            end

            post.save
            posts << post
          end
        end

        posts
      end

    end
  end
end