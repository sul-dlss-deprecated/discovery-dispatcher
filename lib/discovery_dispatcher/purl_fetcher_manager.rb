require 'time'

module DiscoveryDispatcher
  # It manages the reading time from the purl-fetcher server
  # @example Get the next start time
  #   DiscoveryDispatcher::PurlFetcherManager.PurlFetcherManager
  class PurlFetcherManager
    PACIFIC_TIME_ZONE = 'Pacific Time (US & Canada)'

    # @return the next start time to read the records from purl-fetcher. It's will
    #  be the last reading time - 2 minutes.
    def self.get_next_start_time
      next_start_time = ReaderLogRecords.maximum(:last_read_time)
      next_start_time.nil? ? Time.parse('1970-01-01T12:00:00-08:00').in_time_zone(PACIFIC_TIME_ZONE).iso8601 : (next_start_time - 2.minutes).in_time_zone(PACIFIC_TIME_ZONE).iso8601
    end

    # @param last_read_time [Time] the end time for the last visit to purl-fetcher
    # @param no_of_records [int] the number of records that have been read on the last visit to purl-fetcher
    def self.set_last_fetch_info(last_read_time, no_of_records)
      ReaderLogRecords.create(last_read_time: last_read_time.in_time_zone(PACIFIC_TIME_ZONE), record_count: no_of_records)
    end
  end
end
