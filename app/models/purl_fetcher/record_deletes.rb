module PurlFetcher
  class RecordDeletes
    attr_reader :druid, :latest_change
    def initialize(druid:, latest_change: nil)
      @druid = druid
      @latest_change = latest_change
    end

    def enqueue
      Rails.configuration.target_urls_hash.keys.each do |target|
        Delayed::Job.enqueue(
          DiscoveryDispatcher::IndexingJob.new('delete', druid, target)
        )
      end
    end
  end
end
