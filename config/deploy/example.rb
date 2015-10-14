server '', user: '', roles: %w(web app db)

Capistrano::OneTimeKey.generate_one_time_key!

set :deploy_environment, ''
set :whenever_environment, fetch(:deploy_environment)
set :rails_env, ''
