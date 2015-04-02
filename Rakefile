# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

# Executed by the following command 
# cd /...//discovery-dispatcher/current && bundle exec rake RAILS_ENV=development discovery_dispatcher:query_purl_fetcher
namespace :discovery_dispatcher do
  task query_purl_fetcher: :environment do
    puts "Read the new updated items in Purl fetcher"
    DiscoveryDispatcher::Monitor.run
  end
end
