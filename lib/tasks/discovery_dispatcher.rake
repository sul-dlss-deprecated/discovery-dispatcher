namespace :discovery_dispatcher do
  # Executed by the following command
  # cd /opt/app/lyberadmin/discovery-dispatcher/current && bundle exec rake RAILS_ENV=development discovery_dispatcher:query_purl_fetcher
  desc 'Run the discovery dispatch monitor'
  task query_purl_fetcher: :environment do
    DiscoveryDispatcher::Monitor.run
    File.open('log/query_purl_fetcher.log', 'a') { |f| f.write("Read the new updated items in Purl fetcher at #{Time.now}\n") }
  end
end
