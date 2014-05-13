module Storytime
  module MediaHelper
    def show_media_insert_button?
      controller = params[:controller].split("/").last
      controller == "pages" || controller == "posts"
    end

    def full_media_file_url(media)
      if media.file_url.starts_with?("http")
        media.file_url
      else
        root_url[0..-2]+media.file_url
      end
    end
  end
end
