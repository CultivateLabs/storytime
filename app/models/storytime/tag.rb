module Storytime
  class Tag < ActiveRecord::Base
    include Storytime::ScopedToSite
    belongs_to :site
    
    has_many :taggings, dependent: :destroy
    has_many :posts, through: :taggings

    validates :name, presence: true
    validates_uniqueness_of :name, scope: :site_id
  end
end
