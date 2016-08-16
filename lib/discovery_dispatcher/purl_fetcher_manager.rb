require 'time'

module DiscoveryDispatcher
  # It manages the reading time from the purl-fetcher server
  # @example Get the next start time
  #   DiscoveryDispatcher::PurlFetcherManager.next_start_time
  class PurlFetcherManager
    # @return the next start time to read the records from purl-fetcher in UTC. It will be the last reading time - 2 minutes. `nil` if never run
    def self.next_start_time
      next_start_time = ReaderLogRecords.maximum(:last_read_time) # in UTC
      next_start_time -= 2.minutes unless next_start_time.nil? # TODO: why add slop?
      next_start_time
    end

    # @param last_read_time [Time] the end time for the last visit to purl-fetcher
    # @param no_of_records [int] the number of records that have been read on the last visit to purl-fetcher
    def self.set_last_fetch_info(last_read_time, no_of_records)
      ReaderLogRecords.create(last_read_time: last_read_time, record_count: no_of_records)
    end
  end
end
