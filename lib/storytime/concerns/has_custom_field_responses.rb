module Storytime
  module Concerns
    module HasCustomFieldResponses
      def self.included(base)
        raise "Modle must have custom fields to have custom field responses" unless base.method_defined?(:custom_fields)
        base.has_many :custom_field_responses
        base.accepts_nested_attributes_for :custom_field_responses
        base.validate :ensure_single_response_to_custom_fields
      end

      # Gives back the custom field responses for this post combined with initialized CustomFieldResponse objects for any
      # CustomFields in the given post type that are not yet populated
      def initialize_missing_custom_field_responses
        return if custom_fields.empty?
        
        missing_response_field_ids = custom_field_ids - custom_field_responses.map(&:custom_field_id)
        missing_response_field_ids.each do |custom_field_id|
          custom_field_responses.new(custom_field_id: custom_field_id) 
        end
        
        custom_field_responses
      end

      def ensure_single_response_to_custom_fields
        response_field_ids = custom_field_responses.map(&:custom_field_id)
        if response_field_ids.length != response_field_ids.uniq.length
          errors[:base] << "Cannot create more than one response to a custom field for a post."
        end
      end

      def value_for_custom_field_named(field_name)
        custom_field = custom_fields.find_by(name: field_name)
        response = custom_field_responses.find_by(custom_field_id: custom_field)
        response.nil? ? nil : response.value
      end
    end
  end
end

      