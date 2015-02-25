class UpdateStorytimeSiteIdColumns < ActiveRecord::Migration
  def up
    Storytime::Autosave.find_each do |autosave|
      if autosave.site_id.blank?
        autosave.update_column("site_id", autosave.autosavable.site_id)
      end
    end

    Storytime::Comment.find_each do |comment|
      if comment.site_id.blank?
        comment.update_column("site_id", comment.post.site_id)
      end
    end

    Storytime::Version.find_each do |version|
      if version.site_id.blank?
        version.update_column("site_id", version.versionable.site_id)
      end
    end

    Storytime::Tagging.find_each do |tagging|
      if tagging.site_id.blank?
        tagging.update_column("site_id", tagging.post.site_id)
      end
    end
  end

  def down
  end
end
