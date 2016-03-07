# Capistrano::laravel

Deploy Laravel applications with Capistrano v3.*

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano', '~> 3.0.0'
gem 'capistrano-laravel'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-laravel

## Usage

Require the module in your `Capfile`:

```ruby
require 'capistrano/laravel'
```

### Configuration

The gem makes the following configuration variables available (shown with defaults).

```ruby
# Which roles to execute commands on.
set :laravel_roles, :all

# Determines which operations to perform based on which version
# of the Laravel framework your project is using.
set :laravel_version, 5.1

# If using Laravel 5+, a dotenv file is used for environment configuration.
# This variable uploads the given file from the the host to the guest.
set :laravel_dotenv_file, './.env'

# Flags to add to artisan calls.
set :laravel_artisan_flags, "--env=production"

# Will set linked folders based on your Laravel version
set :laravel_set_linked_dirs, false

# Will set ACL paths based on your Laravel version
set :laravel_set_acl_paths, true

# Which user to set ACL permissions for.
set :laravel_server_user, "www-data"
```

### Tasks

The tasks are more or less automatic and are executed as follows:

```ruby
  before "deploy:starting", :prepare_laravel do
    invoke "laravel:configure_folders"
  end

  before "deploy:updated", :laravel_tasks do
    invoke "laravel:upload_dotenv_file"
    invoke "laravel:optimize_release"
    invoke "laravel:create_acl_paths"
    invoke "deploy:set_permissions:acl"
  end
```

#### Task Descriptions

```ruby
# Execute an artisan command
invoke "laravel:artisan", "command"

# Run any optimization commands
invoke "laravel:optimize_release"

# Configure linked dirs/acl dirs
invoke "laravel:configure_folders"

# Upload the dotenv file from local to remote
invoke "laravel:upload_dotenv_file"

# Seed the database
invoke "laravel:seed_db"

# Create any missing folders for ACL
invoke "laravel:create_acl_paths"

# Run migrations for the database
invoke "laravel:migrate_db"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
