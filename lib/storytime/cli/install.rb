module Storytime
  class CLI < Thor
    class Install
      class << self
        include Thor::Actions
        include Thor::Shell

        def options; {}; end

        def storytime_defaults
          hash = {}
          hash[:user_class] = 'User'
          hash[:dashboard_namespace_path] = '/storytime'
          hash[:post_types] = ['CustomPostType']
          hash[:post_title_character_limit] = 100
          hash[:post_excerpt_character_limit] = 500
          hash[:email_regexp] = '/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/'
          hash[:search_adapter] = "''"
          hash[:enable_file_upload] = true
          hash[:aws_region] = "ENV['STORYTIME_AWS_REGION']"
          hash[:aws_access_key_id] = "ENV['STORYTIME_AWS_ACCESS_KEY_ID']"
          hash[:aws_secret_key] = "ENV['STORYTIME_AWS_SECRET_KEY']"
          hash[:s3_bucket] = 'my-s3-bucket'
          hash[:prod_media_storage] = ':s3'
          hash[:dev_media_storage] = ':file'
          hash
        end

        def automated
          `bin/spring stop`

          defaults = storytime_defaults
          self.destination_root = File.expand_path("./")

          say "Starting install of Storytime...", :cyan

          say "Setting up Storytime engine mount point...", :cyan
          inject_storytime_mount("/")
          say "Storytime mount point added to routes file\n\n", :green

          say "Setting up Storytime initializer file...", :cyan
          Storytime::Generators::Initializer.start [storytime_defaults]
          say "Finished setting up Storytime initializer.\n\n", :green

          check_user_model(defaults[:user_class])
          add_storytime_user(defaults[:user_class])
          copy_migrations
          migrate_db
          copy_views

          say "Finished installing Storytime.", :green
          say "Start up your Rails server and navigate to http://localhost:3000#{defaults[:mount_point]} to use Storytime.", :green
        end

        def inject_storytime_mount(mount_point)
          inject_into_file "config/routes.rb", "\n  mount Storytime::Engine => '#{mount_point}'\n", :before => /^end/
        end

        def interactive
          `bin/spring stop`

          begin
            require File.expand_path('config/environment.rb')
          rescue LoadError
            say "This command must be run from the root directory of a Rails app... Change directories and try again.", :red
            return
          end

          say "Starting install of Storytime...", :cyan

          mount_point = add_storytime_mount
          init_hash = setup_initializer_file(mount_point)
          check_user_model(init_hash[:user_class])
          add_storytime_user(init_hash[:user_class])
          copy_migrations
          migrate_db unless no? "Would you like to migrate your database now? [y/n] (y)", :yellow
          copy_views unless no? "Would you like to copy Storytime's views to your host app? [y/n] (y)", :yellow

          say "Finished installing Storytime.", :green
          say "Start up your Rails server and navigate to http://localhost:3000#{mount_point} to use Storytime.", :green
        end

        def add_storytime_mount
          self.destination_root = File.expand_path("./")
          
          say "Setting up Storytime engine mount point...", :cyan
          mount_point = ask "Where would you like to mount Storytime within the host app? (/)", :yellow

          if mount_point.blank?
            mount_point = "/"
          elsif mount_point[0] != "/" 
            mount_point.prepend("/")
          end

          inject_storytime_mount(mount_point)

          say "Storytime mount point added to routes file\n\n", :green

          return mount_point
        end

        def setup_initializer_file(mount_point)
          init_hash = storytime_defaults

          say "Setting up Storytime initializer file...", :cyan

          # User Class
          user_class = ask "Name of the model that you want to use for Storytime users? (User)", :yellow

          unless user_class.blank?
            init_hash[:user_class] = user_class.camelize
            init_hash[:enable_user_class] = true
          end

          # Admin Models
          if yes? "Do you want to enable certain models to be accessible to CRUD operations within the Storytime admin dashboard? [y/n] (n)", :yellow
            admin_models = ask "Enter a comma separated list of the models that you want to be CRUD accessible within the admin dashboard:", :yellow

            unless admin_models.blank?
              admin_models = admin_models.gsub(" ", "").split(",")

              admin_models.each do |model|
                say "Creating a StorytimeAdmin controller for #{model}...", :cyan
                `bin/rails g storytime_admin:resource #{model}`
              end
            end
          end

          # Dashboard Namespace Path
          if no? "Do you want to use /storytime as the location of the dashboard? [y/n] (y)", :yellow
            dashboard_namespace_path = ask "Path of Storytime's dashboard, relative to Storytime's mount point, #{mount_point}, within the host app? (/storytime)", :yellow

            init_hash[:dashboard_namespace_path] = dashboard_namespace_path unless dashboard_namespace_path.blank?
            init_hash[:enable_dashboard_namespace_path] = true
          end
          
          # Custom Post Types
          if yes? "Do you want to use additional post types other than Storytime::Page and Storytime::BlogPost? [y/n] (n)", :yellow
            post_types = ask "Enter a comma separated list of additional post types that you'd like to use:", :yellow

            unless post_types.blank?
              post_types = post_types.gsub(",", " ")

              init_hash[:post_types] = "%w(#{post_types})"
              init_hash[:enable_post_types] = true
            end
          end
          
          # Post Title Character Limit
          post_title_character_limit = ask "What should the character limit be for post titles? (100)", :yellow

          if post_title_character_limit.to_i > 0
            if post_title_character_limit.to_i > 255
              say "Character limit amount exceeds database maximum - setting limit to default/maximum amount (255).", :red
              init_hash[:post_title_character_limit] = 255
            else
              init_hash[:post_title_character_limit] = post_title_character_limit.to_i
            end
            
            init_hash[:enable_post_title_character_limit] = true
          elsif !post_title_character_limit.blank?
            say "Character limit amount is not a valid integer... using the default value (255)", :red
          end
          
          # Post Excerpt Character Limit
          post_excerpt_character_limit = ask "What should the character limit be for post excerpts? (500)", :yellow

          if post_excerpt_character_limit.to_i > 0
            init_hash[:post_excerpt_character_limit] = post_excerpt_character_limit.to_i
            init_hash[:enable_post_excerpt_character_limit] = true
          elsif !post_excerpt_character_limit.blank?
            say "Character limit amount is not a valid integer... using the default value (500) instead.", :red
          end

          # Search Adapters
          app_database = ask "What database is being used to run this application?", :yellow, :limited_to => ["mysql", "postgres", "sqlite3", "other"]
          
          if app_database == "other"
            say "Note: This app will not be able to use Storytime's search feature.", :red
          else
            init_hash[:enable_search_adapter] = true
          end

          if app_database == "mysql"
            if yes? "Does this version support Full-Text search (MySql v5.6.4+)? [y/n] (n)", :yellow
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
          unless no? "Do you want to enable file uploads? [y/n] (y)", :yellow
            init_hash[:enable_file_upload] = true

            prod_media_storage = ask "What type of storage do you want to use for production environments?", :yellow, :limited_to => [":file", ":s3"]
            init_hash[:prod_media_storage] = prod_media_storage

            if prod_media_storage == ":s3"
              s3_bucket = ask "What's the name of your S3 bucket?", :yellow
              
              if s3_bucket.blank?
                say "No S3 bucket was listed... using default (my-s3-bucket) instead. Forgetting to change this before deploying to your production environment WILL result in broken uploads.", :red
              else
                init_hash[:s3_bucket] = s3_bucket
              end
            end
          else
            init_hash[:prod_media_storage] = ":file"
            init_hash[:enable_file_upload] = false
          end
          
          Storytime::Generators::Initializer.start [init_hash]

          say "Finished setting up Storytime initializer.\n\n", :green

          return init_hash
        end

        def check_user_model(user_class)
          unless File.exists?("app/models/#{user_class.underscore}.rb")
            unless File.exists?("config/initializers/devise.rb")
              say "Devise initializer not found... trying to generate one.", :red

              `bin/rails generate devise:install`
            end
            
            say "No #{user_class} model was found... creating one using Devise.", :red

            `bin/rails generate devise #{user_class}`
          end
        end

        def add_storytime_user(user_class)
          self.destination_root = File.expand_path("./")

          say "Adding `storytime_user` to #{user_class} class...", :cyan

          inject_into_file "app/models/#{user_class.underscore}.rb", "\n  storytime_user\n", :before => /^end/

          say "`storytime_user` added to #{user_class} class.\n\n", :green
        end

        def copy_migrations
          say "Copying over Storytime migrations...", :cyan

          `bin/rake storytime:install:migrations`

          say "Finished copying Storytime migrations.\n\n", :green
        end

        def migrate_db
          say "Running database migrations...", :cyan

          `bin/rake db:migrate`

          say "Finished running database migrations.\n\n", :green
        end

        def copy_views
          say "Copying Storytime views...", :cyan

          `bin/rails generate storytime:views`

          say "Finished copying Storytime views.\n\n", :green
        end
      end
    end
  end
end