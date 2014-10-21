module Storytime
  module Dashboard
    module MediaHelper
      def show_media_insert_button?
        params[:controller].split("/").last != "media"
      end

      def full_media_file_url(media, size = nil)
        if media.file_url.starts_with?("http")
          media.file_url(size)
        else
          storytime_root_url[0..-2]+media.file_url(size)
        end
      end
    end
  end
end
