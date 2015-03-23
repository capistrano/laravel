set :laravel_roles, :all
set :laravel_artisan_flags, "--env=production"
set :laravel_server_user, "www-data"
set :laravel_version, 5

# fix bug in capistrano-file-permissions
set :linked_dirs, []

# Use Laravel 5 paths by default
set :file_permissions_paths, [
  'storage',
  'storage/framework/cache',
  'storage/framework/sessions',
  'storage/framework/views',
  'storage/logs',
]

# Load Laravel 4 paths if requested
if :laravel_version == 4
  set :file_permissions_paths, [
    'app/storage',
    'app/storage/cache',
    'app/storage/logs',
    'app/storage/meta',
    'app/storage/sessions',
    'app/storage/views',
  ]
end

set :file_permissions_users, [fetch(:laravel_server_user)]

