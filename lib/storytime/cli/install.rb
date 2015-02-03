module Storytime
  class CLI < Thor
    class Install
      class << self
        include Thor::Shell

        def interactive
          say "Starting install of Storytime...", :cyan

          setup_initializer_file
          # add_storytime_mount
          # add_storytime_user
          # copy_migrations
          # migrate_db
          # copy_views
        end

        def setup_initializer_file
          init_hash = {}
          init_hash[:layout] = 'application'
          init_hash[:user_class] = 'User'
          init_hash[:dashboard_namespace_path] = '/storytime'
          init_hash[:home_page_path] = '/'
          init_hash[:post_types] = ['CustomPostType']
          init_hash[:post_title_character_limit] = 255
          init_hash[:post_excerpt_character_limit] = 500
          init_hash[:whitelisted_html_tags] = '%w(p blockquote pre h1 h2 h3 h4 h5 h6 span ul li ol table tbody td br a img iframe hr)'
          init_hash[:disqus_forum_shortname] = ''
          init_hash[:email_regexp] = '/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/'
          init_hash[:search_adapter] = "''"
          init_hash[:enable_file_upload] = true
          init_hash[:s3_bucket] = 'my-s3-bucket'
          init_hash[:prod_media_storage] = ':s3'
          init_hash[:dev_media_storage] = ':file'

          say "Now setting up a Storytime initializer file...", :yellow

          # Layout
          if no? "Use Storytime's default layout? [y/n] (y)", :red
            layout = ask "Name of the layout to use? e.g the 'application' layout uses /app/views/layout/application, in your host app, as the layout. (application)", :red
            
            init_hash[:layout] = layout unless layout.blank?
            init_hash[:enable_layout] = true
          end

          # User Class
          user_class = ask "Name of the model that you want to use for Storytime users? (User)", :red
          init_hash[:user_class] = user_class unless user_class.blank?

          # Dashboard Namespace Path
          if no? "Do you want to use /storytime as the location of the dashboard? [y/n] (y)", :red
            dashboard_namespace_path = ask "Path of Storytime's dashboard, relative to Storytime's mount point within the host app? (/storytime)", :red

            init_hash[:dashboard_namespace_path] = dashboard_namespace_path unless dashboard_namespace_path.blank?
            init_hash[:enable_dashboard_namespace_path] = true
          end
          
          # Home Page Path
          if no? "Do you wan to use '/' as the location of Storytime's home page? [y/n] (y)", :red
            home_page_path = ask "Path of Storytime's home page, relative to Storytime's mount point within the host app? (/)", :red

            init_hash[:home_page_path] = home_page_path unless home_page_path.blank?
            init_hash[:enable_home_page_path] = true
          end
          
          # Custom Post Types
          if yes? "Do you want to use additional post types other than Storytime::Post and Storytime::BlogPost? [y/n] (n)", :red
            post_types = ask "Enter a comma separated list of additional post types that you'd like to use:", :red

            unless post_types.blank?
              post_types = post_types.gsub(",", " ")

              init_hash[:post_types] = "%w(#{post_types})"
              init_hash[:enable_post_types] = true
            end
          end
          
          # Post Title Character Limit
          post_title_character_limit = ask "What should the character limit be for post titles? (255)", :red

          if post_title_character_limit.to_i > 0
            if post_title_character_limit.to_i > 255
              say "Character limit amount exceeds database maximum - setting limit to default/maximum amount (255).", :yellow
            else
              init_hash[:post_title_character_limit] = post_excerpt_character_limit.to_i
              init_hash[:enable_post_title_character_limit] = true
            end
          elsif !post_title_character_limit.blank?
            say "Character limit amount is not a valid integer... using the default value (255)", :yellow
          end
          
          # Post Excerpt Character Limit
          post_excerpt_character_limit = ask "What should the character limit be for post excerpts? (500)", :red

          if post_excerpt_character_limit.to_i > 0
            init_hash[:post_excerpt_character_limit] = post_excerpt_character_limit.to_i
            init_hash[:enable_post_excerpt_character_limit] = true
          elsif !post_excerpt_character_limit.blank?
            say "Character limit amount is not a valid integer... using the default value (500) instead.", :yellow
          end
          
          # Whitelisted HTML Tags
          # whitelisted_html_tags = ask "Enter a comma separated list of whitelisted tags to allow from the Summernote WYSIWYG Editor.", :red
          # 
          # unless post_types.blank?
          #   whitelisted_html_tags = whitelisted_html_tags.gsub(",", " ")
          # 
          #   init_hash[:whitelisted_html_tags] = "%w(#{whitelisted_html_tags})"
          #   init_hash[:enable_whitelisted_html_tags] = true
          # end
          
          # Disqus Forum Shortname
          if yes? "Do you want to use Disqus for commenting? [y/n] (n)", :red
            disqus_forum_shortname = ask "What is the unique identifier for your website, as registered on Disqus?", :red

            unless disqus_forum_shortname.blank?
              init_hash[:disqus_forum_shortname] = disqus_forum_shortname
              init_hash[:enable_disqus_forum_shortname] = true
            end
          end
          
          # Email REGEX
          # email_regexp = ask "Email regex used to validate emails for subscriptions (/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/)", :red
          # 
          # unless email_regexp.blank?
          #   init_hash[:email_regexp] = email_regexp
          #   init_hash[:enable_email_regexp] = true
          # end

          # Search Adapters
          app_database = ask "What database is being used to run this application?", :red, :limited_to => ["mysql", "postgres", "sqlite3", "other"]
          
          if app_database == "other"
            say "Note: This app will not be able to use Storytime's search feature.", :yellow
          else
            init_hash[:enable_search_adapter] = true
          end

          if app_database == "mysql"
            if yes? "Does this version support Full-Text search (MySql v5.6.4+)? [y/n] (n)", :red
              init_hash[:search_adapter] = Storytime::MysqlFulltextSearchAdapter
            else
              init_hash[:search_adapter] = Storytime::MysqlSearchAdapter
            end
          elsif app_database == "postgres"
            init_hash[:search_adapter] = Storytime::PostgresSearchAdapter
          elsif app_database == "sqlite3"
            init_hash[:search_adapter] = Storytime::Sqlite3SearchAdapter
          end

          # Enable File Upload
          unless no? "Do you want to enable file uploads? [y/n] (y)", :red
            init_hash[:enable_file_upload] = true

            prod_media_storage = ask "What type of storage do you want to use for production environments?", :red, :limited_to => [":file", ":s3"]
            init_hash[:prod_media_storage] = prod_media_storage

            if prod_media_storage == ":s3"
              s3_bucket = ask "What's the name of your S3 bucket?", :red
              
              if s3_bucket.blank?
                say "No S3 bucket was listed... using default (my-s3-bucket) instead. Forgetting to change this before deploying to your production environment WILL result in broken uploads.", :yellow
              else
                init_hash[:s3_bucket] = s3_bucket
              end
            end
          else
            init_hash[:prod_media_storage] = ":file"
            init_hash[:enable_file_upload] = false
          end
          
          Storytime::Generators::Initializer.start [init_hash]
        end

        # def add_storytime_mount
        #   say "Now adding Storytime mount point to routes file", :yellow
        # end

        # def add_storytime_user
        #   say "Now adding `storytime_user` to User class", :yellow
        # end

        # def copy_migrations
        #   say "Now copying over migrations", :yellow
        # end

        # def migrate_db
        #   say "Now running migrations in database", :yellow
        # end

        # def copy_views
        #   say "Now copying views", :yellow
        # end
      end
    end
  end
end