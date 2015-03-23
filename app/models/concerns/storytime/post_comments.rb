module Storytime::PostComments
  extend ActiveSupport::Concern

  included do
    has_many :comments, class_name: "Storytime::Comment", foreign_key: "post_id"

    def show_comments?
      true
    end
  end

  module ClassMethods
    def show_comments?
      true
    end
  end
end