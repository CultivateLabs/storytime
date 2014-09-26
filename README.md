# Storytime

## Setup

Add storytime to your gemfile:

```ruby
gem "storytime"
```

Add a Storytime initializer to your initializers folder:
```ruby
Storytime.configure do |config|
  config.layout = "application"
  config.user_class = User
end
```

Install migrations:
```ruby
rake storytime:install:migrations
rake db:migrate
```

Mount engine in your routes file. If you're mounting at "/", make this the last line in your routes file:
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
  config.user_class = User
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


Lastly, you can add fields to the post form for your custom type. In the host app, add a partial for your fields: ```app/views/storytime/dashboard/posts/_your_post_type_fields.html.erb```, where ```your_post_type``` is the underscored version of your custom post type class (the example class above would be ```_video_post_fields.html.erb```). This partial will be included in the form and passed a form builder variable named f. 

For example, if we had created a migration in the host app to add a url field to the posts table, we could do:
```
# app/views/storytime/dashboard/posts/_video_post_fields.html.erb
<%= f.text_field :url %>
```


