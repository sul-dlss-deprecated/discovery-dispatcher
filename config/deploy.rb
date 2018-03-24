set :application, 'discovery-dispatcher'
set :repo_url, 'https://github.com/sul-dlss/discovery-dispatcher.git'

# Default branch is :master
set :branch, 'master'

set :deploy_to, "/opt/app/lyberadmin/discovery-dispatcher"

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/honeybadger.yml config/secrets.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{config/targets log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system config/settings}

# Default value for keep_releases is 5
set :keep_releases, 5

# honeybadger_env otherwise defaults to rails_env
set :honeybadger_env, "#{fetch(:stage)}"

# Whenever
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

# sidekiq.yml is in shared_configs
set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }
