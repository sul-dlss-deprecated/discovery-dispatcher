module DiscoveryDispatcher
  class Monitor

    def self.run
      begin
        # Prepare start and end time
        start_time = DiscoveryDispatcher::PurlFetcherManager.get_next_start_time
        end_time = Time.now

        # Read the records
        reader = DiscoveryDispatcher::PurlFetcherReader.new(start_time, end_time)
        records = reader.load_records
      
        DiscoveryDispatcher::IndexingJobManager.enqueu_records(records)
      
        DiscoveryDispatcher::PurlFetcherManager.set_last_fetch_info end_time, records.length
      rescue =>e
        # I think we need to raise_error to 
        Rails.logger.error {"Purl fetcher reader failed for the query between #{start_time} and #{end_time}\n#{e.message}"}
        raise e
      end
    end

  end
end
