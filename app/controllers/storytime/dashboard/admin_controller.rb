require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class AdminController < DashboardController
      before_action :load_model, only: [:edit, :update, :destroy]
      before_action :add_view_path
      helper_method :model_name, :model_class, :attributes, :form_attributes

      def index
        @collection = model_class.all
        authorize :admin, :read?
      end

      def new
        @model = model_class.new
        authorize :admin, :create?
      end

      def create
        @model = model_class.new(params[model_name.to_sym].to_hash)
        authorize :admin, :create?

        if @model.save
          redirect_to dashboard_admin_index_path
        else
          render :new
        end
      end

      def edit
        authorize :admin, :update?
      end

      def update
        authorize :admin, :update?

        if @model.update(params[model_name.to_sym].to_hash)
          redirect_to dashboard_admin_index_path
        else
          render :edit
        end
      end

      def destroy
        authorize :admin, :destroy?
        @model.destroy
        redirect_to dashboard_admin_index_path
      end

    private
      def load_model
        @model = model_class.find(params[:id])
      end

      def add_view_path
        prepend_view_path "app/views/#{model_name.pluralize.downcase}"
      end

      def attributes 
        @attributes ||= model_class.columns.map(&:name)
      end

      def form_attributes
        @form_attributes ||= attributes.reject{ |v| form_blacklist.include?(v) }
      end

      def form_blacklist
        ["id", "created_at", "updated_at"]
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