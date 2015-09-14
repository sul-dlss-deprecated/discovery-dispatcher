set :bundle_without, %w{deployment test development staging}.join(' ')
set :rails_env, "production"

Capistrano::OneTimeKey.generate_one_time_key!

namespace :deploy do
  namespace :assets do
    task :symlink do ; end
    task :precompile do ; end
  end
end
