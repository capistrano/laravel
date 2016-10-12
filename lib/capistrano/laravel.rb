require "capistrano/composer"
require "capistrano/file-permissions"
require "capistrano/laravel/version"

load File.expand_path("../tasks/laravel.rake", __FILE__)
