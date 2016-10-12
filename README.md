# Capistrano::Laravel

Deploy Laravel applications with Capistrano v3.*

## Installation

If managing your Capistrano deploy as a ruby project, add this line to your application's Gemfile:

```ruby
gem 'capistrano', '~> 3.0.0'
gem 'capistrano-laravel'
```

And then execute:

```shell
bundle
```

Or install it yourself as:

```shell
gem install capistrano-laravel
```

## Setting up Capistrano

After installing Capistrano, you can use it to initialize a skeleton configuration. To setup Capistrano, please follow the documentation provided on their website:

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
# Which roles to consider as laravel roles
set :laravel_roles, :all

# The artisan flags to include on artisan commands by default
set :laravel_artisan_flags, "--env=#{fetch(:stage)}"

# Which roles to use for running migrations
set :laravel_migration_roles, :all

# The artisan flags to include on artisan commands by default when running migrations
set :laravel_migration_artisan_flags, "--force --env=#{fetch(:stage)}"

# The version of laravel being deployed
set :laravel_version, 5.3

# Which dotenv file to transfer to the server
set :laravel_dotenv_file, './.env'

# The user that the server is running under (used for ACLs)
set :laravel_server_user, 'www-data'

# Ensure the dirs in :linked_dirs exist?
set :laravel_ensure_linked_dirs_exist, true

# Link the directores in laravel_linked_dirs?
set :laravel_set_linked_dirs, true

# Linked directories for a standard Laravel 4 application
set :laravel_4_linked_dirs, [
  'app/storage'
]

# Linked directories for a standard Laravel 5 application
set :laravel_5_linked_dirs, [
  'storage'
]

# Ensure the paths in :file_permissions_paths exist?
set :laravel_ensure_acl_paths_exist, true

# Set ACLs for the paths in laravel_acl_paths?
set :laravel_set_acl_paths, true

# Paths that should have ACLs set for a standard Laravel 4 application
set :laravel_4_acl_paths, [
  'app/storage',
  'app/storage/public',
  'app/storage/cache',
  'app/storage/logs',
  'app/storage/meta',
  'app/storage/sessions',
  'app/storage/views'
]

# Paths that should have ACLs set for a standard Laravel 5 application
set :laravel_5_acl_paths, [
  'bootstrap/cache',
  'storage',
  'storage/app',
  'storage/app/public',
  'storage/framework',
  'storage/framework/cache',
  'storage/framework/sessions',
  'storage/framework/views',
  'storage/logs'
]
```

### Tasks

The following tasks are added to your deploy automagically when adding capistrano/laravel to your deploy.

```ruby
before 'deploy:starting', 'laravel:resolve_linked_dirs'
before 'deploy:starting', 'laravel:resolve_acl_paths'
after  'deploy:starting', 'laravel:ensure_linked_dirs_exist'
after  'deploy:starting', 'laravel:ensure_acl_paths_exist'
after  'deploy:updating', 'deploy:set_permissions:acl'
before 'composer:run',    'laravel:upload_dotenv_file'
after  'composer:run',    'laravel:storage_link'
after  'composer:run',    'laravel:optimize'
```

#### Task Descriptions

```ruby
# Determine which folders, if any, to use for linked directories.
invoke 'laravel:resolve_linked_dirs'

# Determine which paths, if any, to have ACL permissions set.
invoke 'laravel:resolve_acl_paths'

# Ensure that linked dirs exist.
invoke 'laravel:ensure_linked_dirs_exist'

# Ensure that ACL paths exist.
invoke 'laravel:ensure_acl_paths_exist'

# Upload dotenv file for release.
invoke 'laravel:upload_dotenv_file'

# Execute a provided artisan command.
# Replace :command_name with the command to execute
invoke 'laravel:artisan[:command_name]'

# Create a cache file for faster configuration loading
invoke 'laravel:config_cache'

# Create a route cache file for faster route registration
invoke 'laravel:route_cache'

# Optimize the framework for better performance.
invoke 'laravel:optimize'

# Create a symbolic link from "public/storage" to "storage/app/public"
invoke 'laravel:storage_link'

# Run the database migrations.
invoke 'laravel:migrate'

# Rollback the last database migration.
invoke 'laravel:migrate_rollback'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/capistrano/laravel.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
