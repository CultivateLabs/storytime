require_dependency "storytime/application_controller"

module Storytime
  module Dashboard
    class AdminController < DashboardController
      before_action :ensure_valid_model
      before_action :load_model, only: [:edit, :update, :destroy]
      before_action :add_view_path
      helper_method :model_name, :model_class, :attributes, :form_attributes

      def index
        @collection = model_class.storytime_admin_scope(user: current_user, site: current_site).all
        authorize :admin, :read?
      end

      def new
        @model = model_class.new
        authorize :admin, :create?
      end

      def create
        @model = model_class.new(permitted_params)
        authorize :admin, :create?

        if @model.save
          redirect_to dashboard_admin_index_path, notice: t('flash.admin.create.success', resource_name: model_name.titleize)
        else
          render :new
        end
      end

      def edit
        authorize :admin, :update?
      end

      def update
        authorize :admin, :update?

        if @model.update(permitted_params)
          redirect_to dashboard_admin_index_path, notice: t('flash.admin.update.success', resource_name: model_name.titleize)
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
      def ensure_valid_model
        unless Storytime.admin_models.include?(model_name.classify)
          redirect_to storytime.dashboard_path, flash: { error: t('dashboard.admin.unconfigured_model') }
        end
      end

      def load_model
        @model = model_class.find(params[:id])
      end

      def add_view_path
        prepend_view_path "app/views/#{model_name.tableize}"
      end

      def permitted_params
        params.require(model_sym).permit(permitted_attributes.map(&:to_sym))
      end

      def attributes 
        @attributes ||= model_class.columns.map(&:name)
      end

      def form_attributes
        @form_attributes ||= attributes.reject{ |v| form_blacklist.include?(v) }
      end

      def permitted_attributes
        @permitted_attributes ||= attributes.reject{ |v| attribute_blacklist.include?(v) }
      end

      def form_blacklist
        ["id", "created_at", "updated_at"]
      end

      def attribute_blacklist
        ["id", "created_at", "updated_at"]
      end

      def model_sym
        model_name.to_sym
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