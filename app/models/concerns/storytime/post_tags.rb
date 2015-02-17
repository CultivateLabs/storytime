module Storytime::PostTags
  extend ActiveSupport::Concern

  included do
    has_many :taggings, dependent: :destroy, foreign_key: "post_id", class_name: "Storytime::Tagging"
    has_many :tags, through: :taggings, class_name: "Storytime::Tag"

    def tag_list
      tags.map(&:name).join(", ")
    end

    def tag_list=(names_or_ids)
      self.tags = names_or_ids.map do |n|
        if n.empty? || n == "nv__"
          ""
        elsif n.include?("nv__") || n.to_i == 0
          Storytime::Tag.where(name: n.sub("nv__", "").strip).first_or_create do |tag|
            tag.site_id = self.site_id
          end
        else
          Storytime::Tag.find(n)
        end
      end.delete_if { |x| x == "" }
    end
  end

  module ClassMethods
    def tagged_with(name)
      if t = Storytime::Tag.find_by(name: name)
        joins(:taggings).where(storytime_taggings: { tag_id: t.id }) 
      else
        none
      end
    end

    def tag_counts
      Storytime::Tag.select("storytime_tags.*, count(storytime_taggings.tag_id) as count").joins(:taggings).group("storytime_tags.id")
      #Tagging.group("storytime_taggings.tag_id").includes(:tag)
    end
  end
end