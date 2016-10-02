# Capistrano::laravel

Deploy Laravel applications with Capistrano v3.*

## Installation

If managing your Capistrano deploy as a ruby project,
add the following to your gemfile:

```ruby
gem 'capistrano', '~> 3.0.0'
gem 'capistrano-laravel'
```

And then execute:

```shell
bundle
```

If just managing ruby gems on their own on a deploy server,
execute the following to ensure all gems are installed

```shell
gem install capistrano
gem install capistrano-laravel
```

## Setting up Capistrano

After installing Capistrano, you can use it to initialize a skeleton configuration.
To setup Capistrano, please follow the documentation provided on their website:

http://capistranorb.com/documentation/getting-started/preparing-your-application/

This will generate the following files:

```
.
├── Capfile                # Used to manage Capistrano and its dependencies
├── config
│   ├── deploy
│   │   ├── production.rb  # Configuration for production environment
│   │   └── staging.rb     # Configuration for staging environment
│   └── deploy.rb          # Common configuration for all environments
└── lib
    └── capistrano
        └── tasks          # Customized Capistrano tasks for your project
```

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

# Which roles to use for execute migrations
set :laravel_migrate_roels, :all

# Determines which operations to perform based on which version
# of the Laravel framework your project is using.
set :laravel_version, 5.1

# If using Laravel 5+, a dotenv file is used for environment configuration.
# This variable uploads the given file from the the host to the guest.
set :laravel_dotenv_file, './.env'

# Flags to add to artisan calls.
set :laravel_artisan_flags, "--env=production"

# Will set linked folders based on your Laravel version
set :laravel_set_linked_dirs, true

# Will set ACL paths based on your Laravel version
set :laravel_set_acl_paths, true

# Make any missing shared folders if they don't exist
set :laravel_create_linked_acl_paths, true

# Which user to set ACL permissions for.
set :laravel_server_user, "www-data"
```

### Tasks

The following tasks are added to your deploy automagically when
adding capistrano/laravel to your deploy.

```ruby
before 'deploy:starting', 'laravel:configure_folders'
after 'deploy:symlink:shared', 'laravel:create_linked_acl_paths'
after 'deploy:symlink:shared', 'deploy:set_permissions:acl'
after 'deploy:symlink:shared', 'laravel:upload_dotenv_file'
before 'deploy:updated', 'laravel:optimize_release'
```

#### Task Descriptions

```ruby
# Configure linked dirs/acl dirs
invoke "laravel:configure_folders"

# Create any missing folders for ACL
invoke "laravel:create_linked_acl_paths"

# Upload the dotenv file from local to remote
invoke "laravel:upload_dotenv_file"

# Execute an artisan command
invoke "laravel:artisan", "command"

# Run `artisan config:cache` to optimize the configuration
invoke "laravel:optimize_config"

# Run `artisan route:cache` to optimize the routes files
invoke "laravel:optimize_route"

# Run `artisan optimize` to optimize the framework
invoke "laravel:optimize_release"

# Run migrations for the database
invoke "laravel:migrate_db"

# Rollback the database migration
invoke "laravel:rollback_db"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
