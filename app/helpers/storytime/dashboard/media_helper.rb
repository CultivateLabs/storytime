module Storytime
  module Dashboard
    module MediaHelper
      def show_media_insert_button?
        !show_large_gallery?
      end

      def show_large_gallery?
        return false if @large_gallery == false

        referrer_action = request.referrer.nil? ? nil : request.referrer.split("/").last
        controller = params[:controller].split("/").last
        action = params[:action]

        controller == "media" && action == "index" || controller == "media" && action == "create" && referrer_action == "media"
      end

      def gallery_type
        if show_large_gallery?
          "col-md-4 thumb_gallery"
        else
          "tiny_gallery"
        end
      end

      def full_media_file_url(media, size = nil)
        media.file_url(size)
      end
    end
  end
end
