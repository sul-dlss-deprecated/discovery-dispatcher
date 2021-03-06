# @example Run the monitor
#  DispatcherJob.perform_now 
class DispatcherJob < ActiveJob::Base
  # @raise an error if the method faces any problem in reading from purl-fetcher-reader
  def perform
    # Prepare start and end time
    start_time = ReaderLogRecords.last_read_time || Time.zone.parse('1970-01-01T12:00:00-08:00')
    start_time = start_time.iso8601
    end_time = start_time.to_s

    deletes = PurlFetcher::API.new.deletes(first_modified: start_time).count do |record|
      end_time = record['latest_change'] if record['latest_change'] > end_time
      PurlFetcher::RecordDeletes.new(record.deep_symbolize_keys).fanout
    end

    changes = PurlFetcher::API.new.changes(first_modified: start_time).count do |record|
      end_time = record['latest_change'] if record['latest_change'] > end_time
      PurlFetcher::RecordChanges.new(record.deep_symbolize_keys).fanout
    end

    ReaderLogRecords.set_last_fetch_info Time.zone.parse(end_time), (changes + deletes)
  rescue => e
    Rails.logger.error { "Purl fetcher reader failed for the query between #{start_time} and #{end_time}\n#{e.message}" }
    raise e
  end
end
