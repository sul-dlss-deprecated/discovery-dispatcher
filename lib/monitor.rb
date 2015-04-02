module DiscoveryDispatcher
  class Monitor

    def self.run
      begin
        # Prepare start and end time
        start_time = DiscoveryDispatcher::PurlFetcherManager.get_next_start_time
        end_time = Time.now

        # Read the records
        reader = DiscoveryDispatcher::PurlFetcherReader.new(start_time, start_time + end_time)
        records = purl_fetcher_reader.load_records
      
        DiscoveryDispatcher::IndexingJobManager.enqueu_records(records)
      
        DiscoveryDispatcher::PurlFetcherDateManager.set_last_fetch_info end_date, records.length
      rescue =>e
        # I think we need to raise_error to 
        Rails.configuration.logger.error "Purl fetcher reader failed at #{end_date}\n#{e.message}"
      end
    end

  end
end
