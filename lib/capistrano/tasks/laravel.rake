require 'capistrano/laravel/helpers'

include Comparable
include Capistrano::Laravel::Helpers

namespace :load do
  task :defaults do
    set :laravel_roles, :all
    set :laravel_version, 5.1
    set :laravel_artisan_flags, "--env=production"
    set :laravel_server_user, "www-data"

    set :laravel_4_file_permissions_paths, [
      'app/storage',
      'app/storage/cache',
      'app/storage/logs',
      'app/storage/meta',
      'app/storage/sessions',
      'app/storage/views',
    ]
    set :laravel_5_file_permissions_paths, [
      'storage',
      'storage/app',
      'storage/framework',
      'storage/framework/cache',
      'storage/framework/sessions',
      'storage/framework/views',
      'storage/logs',
    ]
    set :laravel_5_1_file_permissions_paths, [
      'bootstrap/cache',
      'storage',
      'storage/app',
      'storage/framework',
      'storage/framework/cache',
      'storage/framework/sessions',
      'storage/framework/views',
      'storage/logs',
    ]
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
  task :optimize do
    invoke "laravel:artisan", "optimize"
  end

  desc "Set the ACL for the web user based on Laravel version."
  task :set_acl do
    if fetch(:laravel_version) < 5
      set :file_permissions_paths, fetch(:file_permissions_paths, []).push(fetch(:laravel_4_file_permissions_paths))
    elsif fetch(:laravel_version) < 5.1
      set :file_permissions_paths, fetch(:file_permissions_paths, []).push(fetch(:laravel_5_file_permissions_paths))
    elsif fetch(:laravel_version) < 5.2
      set :file_permissions_paths, fetch(:file_permissions_paths, []).push(fetch(:laravel_5_1_file_permissions_paths))
    end
    invoke "deploy:set_permissions:acl"
  end

  desc "Migrate the database using Artisan"
  task :migrate do
    within release_path do
      invoke "laravel:artisan", "migrate"
    end
  end
end

namespace :deploy do
  after :updated do
    invoke "laravel:optimize"
    invoke "laravel:set_acl"
  end
end
