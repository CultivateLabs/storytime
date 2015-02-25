module Storytime
  class Autosave < ActiveRecord::Base
    include Storytime::ScopedToSite
    
    belongs_to :user, class_name: Storytime.user_class
    belongs_to :autosavable, polymorphic: true

    attr_accessor :draft_content

    before_save :update_autosave_content

    def update_autosave_content
      self.content = @draft_content
    end
  end
end
