set :application, 'discovery-dispatcher'
set :repo_url, 'https://github.com/sul-dlss/discovery-dispatcher.git'
set :user, 'lyberadmin'

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :home_directory, "/opt/app/#{fetch(:user)}"
set :deploy_to, "#{fetch(:home_directory)}/#{fetch(:application)}"

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/honeybadger.yml config/secrets.yml config/schedule.rb}

# Default value for linked_dirs is []
set :linked_dirs, %w{config/targets log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system config/settings}

# Default value for keep_releases is 5
set :keep_releases, 5

# server uses standardized suffix
server "discovery-dispatcher-#{fetch(:stage)}.stanford.edu", user: fetch(:user), roles: %w{web db app}
set :bundle_without, %w(test deployment development).join(' ')

# honeybadger_env otherwise defaults to rails_env
set :honeybadger_env, "#{fetch(:stage)}"
