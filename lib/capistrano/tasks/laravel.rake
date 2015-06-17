require 'capistrano/laravel/helpers'

include Comparable
include Capistrano::Laravel::Helpers

namespace :load do
  task :defaults do
    set :laravel_roles, :all
    set :laravel_version, 5.1
    set :laravel_dotenv_file, './.env'
    set :laravel_artisan_flags, "--env=production"
    set :laravel_server_user, "www-data"
    set :laravel_linked_dirs, false
    set :laravel_acl_paths, true

    # Folders to link between releases
    set :laravel_4_linked_dirs, [
        'app/storage'
    ]
    set :laravel_5_linked_dirs, [
        'storage'
    ]
    set :laravel_5_1_linked_dirs, fetch(:laravel_5_linked_dirs, []).push('bootstrap/cache')

    # Folders to set permissions on based on laravel version
    set :laravel_4_acl_paths, [
      'app/storage',
      'app/storage/cache',
      'app/storage/logs',
      'app/storage/meta',
      'app/storage/sessions',
      'app/storage/views',
    ]
    set :laravel_5_acl_paths, [
      'storage',
      'storage/app',
      'storage/framework',
      'storage/framework/cache',
      'storage/framework/sessions',
      'storage/framework/views',
      'storage/logs',
    ]
    set :laravel_5_1_acl_paths, fetch(:laravel_5_paths, []).push('bootstrap/cache')

    set :file_permissions_users, [fetch(:laravel_server_user)]
  end
end

namespace :laravel do

  desc "Execute a provided artisan command"
  task :artisan, :command_name do |t, args|
    # ask only runs if argument is not provided
    ask(:cmd, "list")
    command = args[:command_name] || fetch(:cmd)

    on roles fetch(:laravel_roles) do
      within release_path do
        execute :php, :artisan, command, *args.extras, fetch(:laravel_artisan_flags)
      end
    end
  end

  desc "Optimize a Laravel installation for optimimum performance in production."
  task :optimize_laravel do
    if fetch(:laravel_version) >= 5
      invoke "laravel:artisan", "config:cache"
    end

    invoke "laravel:artisan", "optimize"
  end

  desc "Set the ACL for the web user based on Laravel version."
  task :configure_folders do
    if fetch(:laravel_version) < 5
      laravel_linked_dirs = fetch(:laravel_4_linked_dirs)
      laravel_acl_paths = fetch(:laravel_4_acl_paths)
    elsif fetch(:laravel_version) < 5.1
      laravel_linked_dirs = fetch(:laravel_5_linked_dirs)
      laravel_acl_paths = fetch(:laravel_5_acl_paths)
    else
      laravel_linked_dirs = fetch(:laravel_5_1_linked_dirs)
      laravel_acl_paths = fetch(:laravel_5_1_acl_paths)
    end

    if fetch(:laravel_linked_dirs)
      set :linked_dirs, fetch(:linked_dirs, []).push(*laravel_linked_dirs)
    end

    if fetch(:laravel_acl_paths)
      set :file_permissions_paths, fetch(:file_permissions_paths, []).push(*laravel_acl_paths)
    end
  end

  desc "Upload dotenv file for release"
  task :upload_dotenv_file do
    if fetch(:laravel_version) >= 5
      on roles(:all) do
          upload! fetch(:laravel_dotenv_file), "#{release_path}/.env"
      end
    end
  end

  desc "Seed the database."
  task :seed_db do
      on roles(:batch) do
          within "#{current_path}" do
              invoke "laravel:artisan", "db:seed"
          end
      end
  end

  desc "Create missing directories"
  task :create_acl_paths do
    if fetch(:laravel_acl_paths)
      on roles fetch(:laravel_roles) do
        fetch(:file_permissions_paths).each do |path|
          acl_path = release_path.join(path)
          if test("[ ! -e '#{acl_path}' ]")
            execute :mkdir, '-v', acl_path
          else
            info "#{acl_path} already exists."
          end
        end
      end
    end
  end

  desc "Migrate the database using Artisan"
  task :migrate_db do
    within release_path do
      invoke "laravel:artisan", "migrate"
    end
  end
end

namespace :deploy do
  before "deploy:starting", :prepare_laravel do
    invoke "laravel:configure_folders"
  end

  before "deploy:updated", :laravel_tasks do
    invoke "laravel:upload_dotenv_file"
    invoke "laravel:optimize_laravel"
    invoke "laravel:create_acl_paths"
    invoke "deploy:set_permissions:acl"
  end
end
