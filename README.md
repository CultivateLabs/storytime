# Storytime [![Circle CI](https://circleci.com/gh/FlyoverWorks/storytime/tree/master.svg?style=svg)](https://circleci.com/gh/FlyoverWorks/storytime/tree/master)

Storytime is Rails 4+ CMS and blogging engine, with a core focus on content.

## Features

* Simple integration with Rails 4+ apps
* Quick access dashboard
* Multi-site support
* Inline text snippet editing
* CRUD support for managing models
* Email list building
* New post notifications
* Built-in search

## Sample App

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/flyoverworks/storytime-example)

## Installation

Add Storytime to your Gemfile:

```ruby
gem "storytime"
```

Run the bundle command to install it.

After you install Storytime and add it to your Gemfile, you can either setup Storytime through a [guided command line interface](#guided-setup), a speedy [automated setup](#automated-setup), or [manually](#manual-setup).

**Note:** To use the image upload feature, Storytime requires you to have Imagemagick installed on your system.

### Guided Setup

Storytime can set up your routes file, initializer, user model, copy migrations, migrate your database, and copy views into your app through a simple command line interface (CLI). In order to use the CLI, first create a binstub of Storytime by running the following command:

```terminal
$ bundle binstub storytime
```

After creating the binstub just run the following command to get started with the guided setup:

```terminal
$ storytime install
```

After answering the prompts, fire up your Rails server and access the Storytime dashboard, by default located at `http://localhost:3000/storytime`.

### Automated Setup

The automated setup goes through all of the steps in the [Guided Setup](#guided-setup), but instead of prompting you for values it just uses all the defaults, allowing you to setup Storytime in seconds.

In order to use the automated setup, first create a binstub of Storytime (see [Guided Setup](#guided-setup)). Next, run the install command with the -d option:

```terminal
$ storytime install -d
```

After the setup is complete, fire up your Rails server and access the Storytime dashboard, by default located at `http://localhost:3000/storytime`.

### Manual Setup

Manual setup of Storytime assumes that your host app has an authentication system, like [Devise](https://github.com/plataformatec/devise), already installed. *Before proceeding make sure you have properly set up Devise.*

After you install Storytime and add it to your Gemfile, you should run the install generator:

```terminal
$ rails generate storytime:install
```

The install generator will create a Storytime initializer containing various configuration options. Be sure to review and update the generated initializer file as necessary.

Running the install generator will also insert a line into your routes file responsible for mounting the Storytime engine. 

By default, Storytime is mounted at `/`. If you want to keep that mount point make sure that the Storytime mount is the **last** entry in your routes file:

```ruby
mount Storytime::Engine => "/"
```

Install migrations:

```ruby
rake storytime:install:migrations
rake db:migrate
```

Add `storytime_user` to your user class:

```ruby
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  storytime_user
end
```

Finally, fire up your Rails server and access the Storytime dashboard, by default located at `http://localhost:3000/storytime`.

*Optional:* While not necessary, you may want to copy over the non-dashboard Storytime views to your app for customization:

```console
$ rails generate storytime:views
```

## Getting Started

See the [Storytime Wiki](https://github.com/FlyoverWorks/storytime/wiki) for more documentation and information on using Storytime's various features.

## Screen Shots

Page List:
![Page List](https://raw.githubusercontent.com/FlyoverWorks/storytime/master/screenshots/page-list.png "Page List")

Post Editor:
![Post Editor](https://raw.githubusercontent.com/FlyoverWorks/storytime/master/screenshots/post-editor.png "Post Editor")

Text Snippets:
![Text Snippets](https://raw.githubusercontent.com/FlyoverWorks/storytime/master/screenshots/text-snippets.png "Text Snippets")

User Management:
![User Management](https://raw.githubusercontent.com/FlyoverWorks/storytime/master/screenshots/user-management.png "User Management")

Site Settings:
![Site Settings](https://raw.githubusercontent.com/FlyoverWorks/storytime/master/screenshots/site-settings.png "Site Settings")

Media Uploads:
![Media Uploads](https://raw.githubusercontent.com/FlyoverWorks/storytime/master/screenshots/media.png "Media Uploads")

## Copyright
Copyright © 2014-2015 FlyoverWorks Inc. Storytime is released under the [MIT-LICENSE](MIT-LICENSE).