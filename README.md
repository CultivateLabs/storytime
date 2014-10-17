# Storytime

## Setup

Add storytime to your gemfile:

```ruby
gem "storytime"
```

Run the install generator:

  $ rails generate storytime:install

The generator will install a Storytime initializer containing various configuration options. After running the install generator be sure to review and update the generated initializer file as necessary.

Install migrations:
```ruby
rake storytime:install:migrations
rake db:migrate
```

Review your routes file... The Storytime installer will add a line to your routes file that is responsible for mounting the Storytime engine. If you're mounting at "/", make this the **last** line in your routes file:
```ruby
mount Storytime::Engine => "/"
```

Add storytime to your user class:
```ruby
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  storytime_user
end
```

## Custom Post Types

Storytime supports custom post types and takes the opinion that these are a concern of the host app. To add a custom post type, define a new model in your host app that inherits from Storytime's post class.

```ruby
class VideoPost < Storytime::Post
  def show_comments?
    true
  end

  def self.included_in_primary_feed?
    true
  end
end
```

You then need to register the post type in your Storytime initializer:
```ruby
Storytime.configure do |config|
  config.layout = "application"
  config.user_class = 'User'
  config.post_types += ["VideoPost"]
end
``` 

In your subclass, you can override some options for your post type:

```ruby
show_comments?
```
This determines whether comments will be shown on the post.

```ruby
included_in_primary_feed?
```
Defines whether the post type should show up in the primary post feed. If your definition of this method returns false, a new link will be shown in the dashboard header. If it returns true, Storytime will show it as an option in the new post button on the dashboard.


Additionally, you can add fields to the post form for your custom type. In the host app, add a partial for your fields: ```app/views/storytime/dashboard/posts/_your_post_type_fields.html.erb```, where ```your_post_type``` is the underscored version of your custom post type class (the example class above would be ```_video_post_fields.html.erb```). This partial will be included in the form and passed a form builder variable named f. 

For example, if we had created a migration in the host app to add a url field to the posts table, we could do:
```
# app/views/storytime/dashboard/posts/_video_post_fields.html.erb
<%= f.text_field :url %>
```

To create a custom #show view for your custom type, we could add one to ```app/views/storytime/your_post_type/show.html.erb```, where ```your_post_type``` is the underscored version of your custom post type class (the example class above would be ```video_post```).


## Using S3 for Image Uploads

In your initializer, change the media storage to s3 and define an s3 bucket:
```
Storytime.configure do |config|
  if Rails.env.production?
    config.s3_bucket = "my-s3-bucket"
    config.media_storage = :s3
  else
    config.media_storage = :file
  end
end
```

Then, you need to set ```STORYTIME_AWS_ACCESS_KEY_ID``` and ```STORYTIME_AWS_SECRET_KEY``` environment variables on your server.
