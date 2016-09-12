namespace :discovery_dispatcher do
  # Executed by the following command
  # cd /opt/app/lyberadmin/discovery-dispatcher/current && bundle exec rake RAILS_ENV=development discovery_dispatcher:query_purl_fetcher
  desc 'Run the discovery dispatch monitor'
  task query_purl_fetcher: :environment do
    DiscoveryDispatcher::Monitor.run
    File.open('log/query_purl_fetcher.log', 'a') { |f| f.write("Read the new updated items in Purl fetcher at #{Time.now}\n") }
  end

  desc 'Clear out reader logs to restart indexing from the beginning of unix time'
  task clear_reader_logs: :environment do
    ReaderLogRecords.delete_all
  end

  desc 'Clear out Sidekiq jobs'
  task clear_sidekiq: :environment do
    Sidekiq::Queue.new('default').clear   # clear the default queue
    Sidekiq::RetrySet.new.clear           # clear the retry set
    Sidekiq::ScheduledSet.new.clear       # clear the scheduled set
    Sidekiq::Stats.new.reset              # reset dashboard statistics
  end
end
