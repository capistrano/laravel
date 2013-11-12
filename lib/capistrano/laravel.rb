require "capistrano/composer"
require "capistrano/file-permissions"
require "capistrano/laravel/artisan"
require "capistrano/laravel/laravel"
# require "capistrano/laravel/migrations"

namespace :load do
  task :defaults do
    load 'capistrano/laravel/defaults.rb'
  end
end
