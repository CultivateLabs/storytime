module Storytime
  module Migrators
    module V1
      def self.create_user_memberships
        Storytime.user_class.find_each do |user|
          Storytime::Site.find_each do |site|
            if user.storytime_role_id.present?
              Storytime::Membership.create(site_id: site.id, user_id: user.id, storytime_role_id: user.storytime_role_id)
              # set as site creator if site.user_id is blank and role is admin
              if site.user_id.blank? && user.storytime_role_id == Storytime::Role.find_by(name: "admin").id
                site.update_column "user_id", user.id
              end
            end
          end
        end
      end

      def self.set_site_layout
        Storytime::Site.find_each do |site|
          site.update_column "layout", Storytime.layout
        end
      end

      def self.add_site_id_to_media
        Storytime::Media.find_each do |media|
          if media.site_id.blank?
            media.update_column("site_id", Storytime::Site.first.id)
          end
        end
      end

      def self.add_site_id_to_autosaves
        Storytime::Autosave.find_each do |autosave|
          if autosave.site_id.blank?
            autosave.update_column("site_id", autosave.autosavable.site_id)
          end
        end
      end

      def self.add_site_id_to_comments
        Storytime::Comment.find_each do |comment|
          if comment.site_id.blank?
            comment.update_column("site_id", comment.post.site_id)
          end
        end
      end

      def self.add_site_id_to_versions
        Storytime::Version.find_each do |version|
          if version.site_id.blank?
            version.update_column("site_id", version.versionable.site_id)
          end
        end
      end

      def self.add_site_id_to_taggings
        Storytime::Tagging.find_each do |tagging|
          if tagging.site_id.blank?
            tagging.update_column("site_id", tagging.post.site_id)
          end
        end
      end

      def self.add_site_id_to_posts
        site = Storytime::Site.first
        Storytime::Post.all.each do |post|
          if post.site_id.blank?
            post.update_attributes(site_id: site.id)
          end
        end
      end

      def self.add_site_id_to_snippets
        site = Storytime::Site.first
        Storytime::Snippet.all.each do |snippet|
          if snippet.site_id.blank?
            snippet.update_attributes(site_id: site.id)
          end
        end
      end

      def self.add_site_id_to_tags
        site = Storytime::Site.first
        Storytime::Tag.all.each do |tag|
          if tag.site_id.blank?
            tag.update_attributes(site_id: site.id)
          end
        end
      end

      def self.create_default_blog_for_sites
        Storytime::Site.find_each do |site|
          blog = site.blogs.new
          blog.published_at = Time.now
          blog.title = "Blog"
          blog.draft_content = "Test"
          blog.slug = "blog"
          blog.user = Storytime.user_class.first
          blog.save
          if site.root_page_content == 0 
            site.homepage = blog
            site.save
          end
        end
      end

      def self.transfer_posts_to_blogs
        Storytime::BlogPost.reset_column_information
        
        Storytime::Site.find_each do |site|
          default_blog = site.blogs.first
          
          Storytime::BlogPost.all.find_each do |post|
            post.blog = default_blog
            post.save
          end
        end
      end

    end
  end
end