module Storytime
  class CustomFieldResponse < ActiveRecord::Base
    belongs_to :post
    belongs_to :custom_field

    # validates :post, presence: true
    validates :custom_field, presence: true

    validates :custom_field_id, uniqueness: { scope: :post_id } # only one response per field/post combo
  end
end
