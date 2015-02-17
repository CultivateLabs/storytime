module Storytime::PostComments
  extend ActiveSupport::Concern

  included do
    has_many :comments
  end

  module ClassMethods
    def show_comments?
      true
    end
  end
end