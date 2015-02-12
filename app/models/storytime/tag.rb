module Storytime
  class Tag < ActiveRecord::Base
    belongs_to :site
    
    has_many :taggings, dependent: :destroy
    has_many :posts, through: :taggings

    validates :name, presence: true, uniqueness: true
  end
end
