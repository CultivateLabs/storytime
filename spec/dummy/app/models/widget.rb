class Widget < ActiveRecord::Base
  validates_presence_of :name

  storytime_admin_model scope: ->(opts){ where(user: opts[:user]).where(site: opts[:site]) }
end