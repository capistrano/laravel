include Comparable

namespace :load do
  task :defaults do
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

    # Whether to upload the dotenv file on deploy
    set :laravel_upload_dotenv_file_on_deploy, true

    # Which dotenv file to transfer to the server
    set :laravel_dotenv_file, ".env"

    # The user that the server is running under (used for ACLs)
    set :laravel_server_user, "www-data"

    # Ensure the dirs in :linked_dirs exist?
    set :laravel_ensure_linked_dirs_exist, true

    # Link the directores in laravel_linked_dirs?
    set :laravel_set_linked_dirs, true

    # Linked directories for a standard Laravel 4 application
    set :laravel_4_linked_dirs, [
      "app/storage/public",
      "app/storage/cache",
      "app/storage/logs",
      "app/storage/meta",
      "app/storage/sessions",
      "app/storage/views"
    ]

    # Linked directories for a standard Laravel 5 application
    set :laravel_5_linked_dirs, [
      "storage/app",
      "storage/framework/cache",
      "storage/framework/sessions",
      "storage/framework/views",
      "storage/logs"
    ]

    # Ensure the paths in :file_permissions_paths exist?
    set :laravel_ensure_acl_paths_exist, true

    # Set ACLs for the paths in laravel_acl_paths?
    set :laravel_set_acl_paths, true

    # Paths that should have ACLs set for a standard Laravel 4 application
    set :laravel_4_acl_paths, [
      "app/storage",
      "app/storage/public",
      "app/storage/cache",
      "app/storage/logs",
      "app/storage/meta",
      "app/storage/sessions",
      "app/storage/views"
    ]

    # Paths that should have ACLs set for a standard Laravel 5 application
    set :laravel_5_acl_paths, [
      "bootstrap/cache",
      "storage",
      "storage/app",
      "storage/app/public",
      "storage/framework",
      "storage/framework/cache",
      "storage/framework/sessions",
      "storage/framework/views",
      "storage/logs"
    ]
  end
end

namespace :laravel do
  desc "Determine which folders, if any, to use for linked directories."
  task :resolve_linked_dirs do
    laravel_version = fetch(:laravel_version)

    # Use Laravel 5 linked dirs by default
    laravel_linked_dirs = fetch(:laravel_5_linked_dirs)

    # Laravel 4
    laravel_linked_dirs = fetch(:laravel_4_linked_dirs) if laravel_version < 5

    if fetch(:laravel_set_linked_dirs)
      set :linked_dirs, fetch(:linked_dirs, []).push(*laravel_linked_dirs)
    end
  end

  desc "Determine which paths, if any, to have ACL permissions set."
  task :resolve_acl_paths do
    next unless fetch(:laravel_set_acl_paths)
    laravel_version = fetch(:laravel_version)

    # Use Laravel 5 ACL paths by default
    laravel_acl_paths = fetch(:laravel_5_acl_paths)

    # Laravel 4
    laravel_acl_paths = fetch(:laravel_4_acl_paths) if laravel_version < 5

    set :file_permissions_paths, fetch(:file_permissions_paths, []).push(*laravel_acl_paths).uniq
    set :file_permissions_users, fetch(:file_permissions_users, []).push(fetch(:laravel_server_user)).uniq
  end

  desc "Ensure that linked dirs exist."
  task :ensure_linked_dirs_exist do
    next unless fetch(:laravel_ensure_linked_dirs_exist)

    on roles fetch(:laravel_roles) do
      fetch(:linked_dirs).each do |path|
        within shared_path do
          execute :mkdir, "-p", path
        end
      end
    end
  end

  desc "Ensure that ACL paths exist."
  task :ensure_acl_paths_exist do
    next unless fetch(:laravel_set_acl_paths) && fetch(:laravel_ensure_acl_paths_exist)

    on roles fetch(:laravel_roles) do
      fetch(:file_permissions_paths).each do |path|
        within release_path do
          execute :mkdir, "-p", path
        end
      end
    end
  end

  desc "Upload dotenv file for release."
  task :upload_dotenv_file do
    next unless fetch(:laravel_upload_dotenv_file_on_deploy)

    # Dotenv was introduced in Laravel 5
    next if fetch(:laravel_version) < 5

    dotenv_file = fetch(:laravel_dotenv_file)

    run_locally do
      if dotenv_file.empty? || test("[ ! -e #{dotenv_file} ]")
        raise Capistrano::ValidationError, "Must prepare dotenv file [#{dotenv_file}] locally before deploy!"
      end
    end

    on roles fetch(:laravel_roles) do
      upload! dotenv_file, "#{release_path}/.env"
    end
  end

  desc "Execute a provided artisan command."
  task :artisan, [:command_name] do |_t, args|
    ask(:cmd, "list") # Ask only runs if argument is not provided
    command = args[:command_name] || fetch(:cmd)

    on roles fetch(:laravel_roles) do
      within release_path do
        execute :php, :artisan, command, *args.extras, fetch(:laravel_artisan_flags)
      end
    end

    # Enable task artisan to be ran more than once
    Rake::Task["laravel:artisan"].reenable
  end

  desc "Create a cache file for faster configuration loading."
  task :config_cache do
    next if fetch(:laravel_version) < 5
    Rake::Task["laravel:artisan"].invoke("config:cache")
  end

  desc "Create a route cache file for faster route registration."
  task :route_cache do
    next if fetch(:laravel_version) < 5
    Rake::Task["laravel:artisan"].invoke("route:cache")
  end

  desc "Optimize the framework for better performance."
  task :optimize do
    next if fetch(:laravel_version) >= 5.5
    Rake::Task["laravel:artisan"].invoke(:optimize, "--force")
  end

  desc "Create a symbolic link from \"public/storage\" to \"storage/app/public.\""
  task :storage_link do
    next if fetch(:laravel_version) < 5.3
    Rake::Task["laravel:artisan"].invoke("storage:link")
  end

  desc "Run the database migrations."
  task :migrate do
    laravel_roles = fetch(:laravel_roles)
    laravel_artisan_flags = fetch(:laravel_artisan_flags)

    set(:laravel_roles, fetch(:laravel_migration_roles))
    set(:laravel_artisan_flags, fetch(:laravel_migration_artisan_flags))

    Rake::Task["laravel:artisan"].invoke(:migrate)

    set(:laravel_roles, laravel_roles)
    set(:laravel_artisan_flags, laravel_artisan_flags)
  end

  desc "Rollback the last database migration."
  task :migrate_rollback do
    laravel_roles = fetch(:laravel_roles)
    laravel_artisan_flags = fetch(:laravel_artisan_flags)

    set(:laravel_roles, fetch(:laravel_migration_roles))
    set(:laravel_artisan_flags, fetch(:laravel_migration_artisan_flags))

    Rake::Task["laravel:artisan"].invoke("migrate:rollback")

    set(:laravel_roles, laravel_roles)
    set(:laravel_artisan_flags, laravel_artisan_flags)
  end

  before "deploy:starting", "laravel:resolve_linked_dirs"
  before "deploy:starting", "laravel:resolve_acl_paths"
  after  "deploy:starting", "laravel:ensure_linked_dirs_exist"
  after  "deploy:updating", "laravel:ensure_acl_paths_exist"
  before "deploy:updated",  "deploy:set_permissions:acl"
  before "composer:run",    "laravel:upload_dotenv_file"
  after  "composer:run",    "laravel:storage_link"
  after  "composer:run",    "laravel:optimize"
end
