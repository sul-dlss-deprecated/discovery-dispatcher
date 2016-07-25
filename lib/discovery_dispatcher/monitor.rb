module DiscoveryDispatcher
  # It's responsible for initiating the purl fetcher reader since
  # the last read time -2 minutes.
  # @example Run the monitor
  #   DiscoveryDispatcher::Monitor.run
  class Monitor
    # @raise an error if the method faces any problem in reading from purl-fetcher-reader
    def self.run
      # Prepare start and end time
      start_time = DiscoveryDispatcher::PurlFetcherManager.next_start_time
      end_time = Time.now

      # Read the records
      reader = DiscoveryDispatcher::PurlFetcherReader.new(start_time, end_time)
      records = reader.load_records

      DiscoveryDispatcher::IndexingJobManager.enqueue_records(records)

      DiscoveryDispatcher::PurlFetcherManager.set_last_fetch_info end_time, records.length
    rescue => e
      Rails.logger.error { "Purl fetcher reader failed for the query between #{start_time} and #{end_time}\n#{e.message}" }
      raise e
    end
  end
end
