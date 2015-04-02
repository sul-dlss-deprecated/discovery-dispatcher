module DiscoveryDispatcher
  class IndexingJobManager
    
    def self.enqueu_records records
      records.each do |record|
        if record[:type] == "delete" then
          enqueu_delete_record record
        else
          enqueu_index_record record
        end
      end
    end  
      
    def self.enqueu_delete_record record
      # Iterate through the registered target in the target_url config
      target_urls_hash = Rails.configuration.target_urls
      target_urls_hash.each do |target| 
        Delayed::Job.enqueue(IndexingJob.new(record[:type], record[:druid_id], target, record[:subtargets] )) 
      end
    end
    
    def self.enqueu_index_record record
      # Iterate through thre target list in the purl fetcher record
      unless record[:targets].nil? then
        record[:target].each do |target|        
          Delayed::Job.enqueue(IndexingJob.new(record[:type], record[:druid_id], target, record[:subtargets] ))
        end
      end      
    end

  end
end