lock '3.4.0'

set :application, 'discovery-dispatcher'
set :repo_url, 'https://github.com/sul-dlss/discovery-dispatcher.git'
set :user, ask('User', 'enter in the app username')

set :home_directory, "/opt/app/#{fetch(:user)}"
set :deploy_to, "#{fetch(:home_directory)}/#{fetch(:application)}"

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/initializers/squash.rb')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push(
  'config/environments',
  'config/targets',
  'log',
  'tmp/pids',
  'tmp/cache',
  'tmp/sockets',
  'vendor/bundle',
  'public/system'
)

set :branch, 'master'

set :deploy_host, ask('Server', 'enter in the server you are deploying to. do not include .stanford.edu')
# set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
server "#{fetch(:deploy_host)}.stanford.edu", user: fetch(:user), roles: %w(web db app)
namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'delayed_job:restart'
    end
    invoke 'passenger:restart'
  end

  after :publishing, :restart
end

before 'deploy:publishing', 'squash:write_revision'
