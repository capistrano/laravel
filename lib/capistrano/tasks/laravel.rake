namespace :deploy do
  task :optimize do
    invoke "laravel:artisan", "optimize"
  end

  after :updated, "deploy:optimize"
  after :updated, 'deploy:set_permissions:acl'
end
