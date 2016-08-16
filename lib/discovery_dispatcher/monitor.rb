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
      end_time = Time.now.in_time_zone('Pacific Time (US & Canada)').iso8601

      deletes = PurlFetcher::API.new.deletes(first_modified: start_time, last_modified: end_time).map do |record|
        PurlFetcher::RecordDeletes.new(record.deep_symbolize_keys).enqueue
      end

      changes = PurlFetcher::API.new.changes(first_modified: start_time, last_modified: end_time).map do |record|
        PurlFetcher::RecordChanges.new(record.deep_symbolize_keys).enqueue
      end

      DiscoveryDispatcher::PurlFetcherManager.set_last_fetch_info end_time, (changes.size + deletes.size)
    rescue => e
      Rails.logger.error { "Purl fetcher reader failed for the query between #{start_time} and #{end_time}\n#{e.message}" }
      raise e
    end
  end
end
