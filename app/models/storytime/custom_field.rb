module Storytime
  class CustomField < ActiveRecord::Base
    belongs_to :post_type

    TYPES = %w{TextField}

    def self.type_classes
      TYPES.map{|type| "Storytime::CustomFields::#{type}" }
    end
  end
end
