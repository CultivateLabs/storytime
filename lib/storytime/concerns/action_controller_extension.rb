module Storytime
  module ActionControllerExtension
    
    def self.included(base)
      base.extend(ClassMethods)
      base.helper_method :current_tab, :current_tab? if base.respond_to?(:helper_method)
    end

    def set_tab(name, namespace = nil)
      tab_stack[namespace || :default] = name
    end

    def current_tab(namespace = nil)
      tab_stack[namespace || :default]
    end

    def current_tab?(name, namespace = nil)
      current_tab(namespace).to_s == name.to_s
    end

    def tab_stack
      @tab_stack ||= {}
    end

    module ClassMethods
      def set_tab(*args)
        options = args.extract_options!
        name, namespace = args

        before_action(options) do |controller|
          controller.send(:set_tab, name, namespace)
        end
      end
    end
  end
end
