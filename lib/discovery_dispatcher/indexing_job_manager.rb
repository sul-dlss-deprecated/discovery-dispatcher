module DiscoveryDispatcher
  # Manages indexing jobs queues
  class IndexingJobManager
    def self.enqueue_records(records)
      records.each do |record|
        if record[:type] == 'delete_from_all'
          enqueue_delete_record_from_all_targets record.deep_symbolize_keys
        else
          Delayed::Job.enqueue(indexing_job(record))
        end
      end
    end

    def self.enqueue_delete_record_from_all_targets(record)
      # Iterate through all the registered targets in the target_url config
      target_urls_hash = Rails.configuration.targets_url_hash
      target_urls_hash.keys.each do |target|
        Delayed::Job.enqueue(delete_all_job(record, target))
      end
    end

    def self.get_target_url(target)
      target_urls_hash = Rails.configuration.targets_url_hash
      target_urls_hash.include?(target) ? target_urls_hash[target]['url'] : nil
    end

    def self.delete_all_job(record, target)
      IndexingJob.new("delete", record[:druid], target)
    end

    def self.indexing_job(record)
      IndexingJob.new(record[:type], record[:druid], record[:target])
    end
  end
end
