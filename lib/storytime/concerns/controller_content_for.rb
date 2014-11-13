module Storytime
  module Concerns
    module ControllerContentFor

      def view_context
        super.tap do |view|
          (@_content_for || {}).each do |name,content|
            view.content_for name, content
          end
        end
      end

      def content_for(name, content) # no blocks allowed yet
        @_content_for ||= {}
        if @_content_for[name].respond_to?(:<<)
          @_content_for[name] << content
        else
          @_content_for[name] = content
        end
      end

      def content_for?(name)
        @_content_for[name].present?
      end

    end
  end
end