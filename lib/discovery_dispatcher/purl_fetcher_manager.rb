require 'time'

module DiscoveryDispatcher
  class PurlFetcherManager
    
    PACIFIC_TIME_ZONE = 'Pacific Time (US & Canada)'
    def self.get_next_start_time
      next_start_time = ReaderLogRecords.maximum(:last_read_time) 
      return next_start_time.nil? ? Time.parse("1970-01-01T12:00:00").in_time_zone(PACIFIC_TIME_ZONE) : next_start_time.in_time_zone(PACIFIC_TIME_ZONE)
    end
    
    def self.set_last_fetch_info(last_read_time, no_of_records)
      ReaderLogRecords.create(last_read_time: Time.parse(last_read_time).utc, record_count: no_of_records)
    end
  end
end