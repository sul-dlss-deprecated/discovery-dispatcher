module DiscoveryDispatcher
  # Manages indexing jobs queues
  class IndexingJobManager
    def self.enqueue_records(records)
      records.each do |record|
        if record[:type] == 'delete'
          enqueue_delete_record record.deep_symbolize_keys
        else
          enqueue_index_record record.deep_symbolize_keys
        end
      end
    end

    def self.enqueue_delete_record(record)
      # Iterate through the registered target in the target_url config
      target_urls_hash = Rails.configuration.targets_url_hash
      target_urls_hash.keys.each do |target|
        Delayed::Job.enqueue(IndexingJob.new(record[:type], record[:druid], target))
      end
    end

    def self.enqueue_index_record(record)
      uniq_targets = merge_and_uniq_targets record[:true_targets], record[:false_targets]

      # Iterate through thre target list in the purl fetcher record
      uniq_targets.each do |target|
        Delayed::Job.enqueue(IndexingJob.new(record[:type], record[:druid], target))
      end
    end

    def self.merge_and_uniq_targets(true_targets, false_targets)
      all_targets = []
      all_targets.concat true_targets unless true_targets.nil?
      all_targets.concat false_targets unless false_targets.nil?

      uniq_targets_hash = {}
      all_targets.each do |target|
        target_url = get_target_url target
        if target_url.nil? || uniq_targets_hash.values.include?(target_url) == false

          uniq_targets_hash[target] = target_url
        end
      end
      uniq_targets_hash.keys
    end

    def self.get_target_url(target)
      target_urls_hash = Rails.configuration.targets_url_hash
      target_urls_hash.include?(target) ? target_urls_hash[target]['url'] : nil
    end
  end
end
