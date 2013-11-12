namespace :deploy do
  task :migrate do
    within release_path do
      invoke "laravel:artisan", "migrate"
    end
  end
end
