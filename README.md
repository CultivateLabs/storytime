= Storytime

### Setup

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
