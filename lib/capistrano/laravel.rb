require "capistrano/composer"
require "capistrano/file-permissions"
require "capistrano/npm"
require "capistrano/gulp"

load File.expand_path("../tasks/laravel.rake", __FILE__)
