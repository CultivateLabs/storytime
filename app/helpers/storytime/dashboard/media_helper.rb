module Storytime
  module Dashboard
    module MediaHelper
      def show_media_insert_button?
        referrer_action = request.referrer.nil? ? nil : request.referrer.split("/").last
        params[:controller].split("/").last != "media" || referrer_action == "edit"
      end

      def show_large_gallery?
        referrer_action = request.referrer.nil? ? nil : request.referrer.split("/").last
        params[:controller].split("/").last != "media" || referrer_action != "edit"
      end

      def full_media_file_url(media, size = nil)
        if media.file_url.starts_with?("http")
          media.file_url(size)
        else
          storytime_root_post_url[0..-2]+media.file_url(size)
        end
      end
    end
  end
end
