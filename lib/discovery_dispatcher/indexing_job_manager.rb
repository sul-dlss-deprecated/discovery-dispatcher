module DiscoveryDispatcher
  # Manages indexing jobs queues
  class IndexingJobManager
    # Loop over all records and determine proper processing based upon record
    # type and the existence of a specified target
    def self.enqueue_records(records)
      records.each do |record|
        if record[:type] == 'delete' && record[:target].nil?
          enqueue_delete_record_from_all_targets record.deep_symbolize_keys
        elsif !record[:target].nil?
          enqueue_process_record record.deep_symbolize_keys
        end
      end
    end

    # Delete record from all targets is determined by the fact that the
    # record type is delete but there are no specified targets
    def self.enqueue_delete_record_from_all_targets(record)
      # Iterate through the registered targets in the target_url config
      target_hash = Rails.configuration.target_urls_hash
      target_hash.keys.each do |target|
        Delayed::Job.enqueue(IndexingJob.new(record[:type], record[:druid], target))
      end
    end

    # As long as there is a specified target, process the record as an index
    # or delete based upon record type for the specified target
    def self.enqueue_process_record(record)
      Delayed::Job.enqueue(IndexingJob.new(record[:type], record[:druid], record[:target]))
    end
  end
end
