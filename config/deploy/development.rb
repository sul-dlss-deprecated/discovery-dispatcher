server 'discovery-dispatcher-dev', user: 'lyberadmin', roles: %w{web app db}

Capistrano::OneTimeKey.generate_one_time_key!

set :deploy_environment, 'development'
set :whenever_environment, fetch(:deploy_environment)

