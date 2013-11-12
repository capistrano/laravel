set :laravel_roles, :all
set :laravel_artisan_flags, "--env production"
set :laravel_server_user, "www-data"

# fix bug in capistrano-file-permissions
set :linked_dirs, []

set :file_permissions_paths, [
  'app/storage',
  'app/storage/cache',
  'app/storage/logs',
  'app/storage/meta',
  'app/storage/sessions',
  'app/storage/views',
]
set :file_permissions_users, [fetch(:webserver_user)]

