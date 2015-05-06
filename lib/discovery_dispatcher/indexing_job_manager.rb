module DiscoveryDispatcher
  class IndexingJobManager
    
    def self.enqueu_records records
      records.each do |record|
        if record[:type] == "delete" then
          enqueu_delete_record record.deep_symbolize_keys
        else
          enqueu_index_record record.deep_symbolize_keys
        end
      end
    end  
      
    def self.enqueu_delete_record record
      # Iterate through the registered target in the target_url config
      target_urls_hash = Rails.configuration.target_urls
      target_urls_hash.keys.each do |target| 
        Delayed::Job.enqueue(IndexingJob.new(record[:type], record[:druid], target, record[:subtargets] )) 
      end
    end
    
    def self.enqueu_index_record record
      # Iterate through thre target list in the purl fetcher record
      unless record[:true_targets].nil? then
        record[:true_targets].each do |target|        
          Delayed::Job.enqueue(IndexingJob.new(record[:type], record[:druid], target, record[:subtargets] ))
        end
      end      
      unless record[:false_targets].nil? then
        record[:false_targets].each do |target|        
          Delayed::Job.enqueue(IndexingJob.new(record[:type], record[:druid], target, record[:subtargets] ))
        end
      end   
    end

  end
end