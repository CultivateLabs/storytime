require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class AdminController < DashboardController
      before_action :add_view_path
      helper_method :model_name, :model_class, :attributes

      def index
        @collection = model_class.all
        authorize :admin, :read?
      end

    private
      def add_view_path
        prepend_view_path "app/views/#{model_name.pluralize.downcase}"
      end

      def attributes 
        @attributes ||= model_class.columns.map(&:name)
      end

      def model_class
        @model_class ||= model_name.classify.constantize
      end

      def model_name
        @model_name ||= params[:resource_name].singularize
      end
    end
  end
end