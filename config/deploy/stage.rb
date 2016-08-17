Capistrano::OneTimeKey.generate_one_time_key!
set :rails_env, 'production'

set :delayed_job_workers, 8
