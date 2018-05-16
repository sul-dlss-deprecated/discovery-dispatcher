# sidekiq processes
set :sidekiq_processes, 1

# server uses standardized suffix
server "discovery-dispatcher-uat.stanford.edu", user: "lyberadmin", roles: %w{web db app}

Capistrano::OneTimeKey.generate_one_time_key!

# all servers (even -dev) will be rails_env production
set :rails_env, 'production'

set :bundle_without, %w(test deployment development).join(' ')
