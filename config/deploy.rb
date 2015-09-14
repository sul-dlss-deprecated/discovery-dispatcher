set :application, 'discovery-dispatcher'
set :repo_url, 'https://github.com/sul-dlss/discovery-dispatcher.git'
set :user, ask("User", 'enter in the app username')

set :home_directory, "/opt/app/#{fetch(:user)}"
set :deploy_to, "#{fetch(:home_directory)}/#{fetch(:application)}"

set :stages, %W(staging development production)

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log config/environments config/targets vendor/bundle public/system tmp/pids}

set :branch, 'master'

set :deploy_host, ask("Server", 'enter in the server you are deploying to. do not include .stanford.edu')
#set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
server "#{fetch(:deploy_host)}.stanford.edu", user: fetch(:user), roles: %w{web db app}
namespace :deploy do




  task :start do
    bundle exec cap setup
  end

  task "assets:precompile" do

  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :mkdir, '-p', "#{release_path}/tmp"
      execute :touch, release_path.join('tmp/restart.txt')
      invoke 'delayed_job:restart'
    end
  end

  after :publishing, "deploy:migrate"
  after "deploy:migrate", :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end


end
