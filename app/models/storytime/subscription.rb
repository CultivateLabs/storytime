module Storytime
  class Subscription < ActiveRecord::Base
    validates_presence_of :email
    validates :email, uniqueness: true
  end
end
