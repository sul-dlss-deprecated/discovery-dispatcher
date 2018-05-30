module DiscoveryDispatcher
  # It's responsible for initiating the purl fetcher reader since
  # the last read time -2 minutes.
  # @example Run the monitor
  #   DiscoveryDispatcher::Monitor.run
  class Monitor
    # @raise an error if the method faces any problem in reading from purl-fetcher-reader
    def self.run
      # Prepare start and end time
      start_time = ReaderLogRecords.last_read_time || Time.zone.parse('1970-01-01T12:00:00-08:00')
      start_time = start_time.iso8601
      end_time = Time.zone.now.iso8601

      deletes = PurlFetcher::API.new.deletes(first_modified: start_time, last_modified: end_time).map do |record|
        PurlFetcher::RecordDeletes.new(record.deep_symbolize_keys).fanout
      end

      changes = PurlFetcher::API.new.changes(first_modified: start_time, last_modified: end_time).map do |record|
        PurlFetcher::RecordChanges.new(record.deep_symbolize_keys).fanout
      end

      ReaderLogRecords.set_last_fetch_info end_time, (changes + deletes)
    rescue => e
      Rails.logger.error { "Purl fetcher reader failed for the query between #{start_time} and #{end_time}\n#{e.message}" }
      raise e
    end
  end
end
