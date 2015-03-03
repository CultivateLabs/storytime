class Widget < ActiveRecord::Base
  validates_presence_of :name

  storytime_admin_model #scope: ->(opts){ where(user_id: opts[:user], site_id: opts[:site]) }
end