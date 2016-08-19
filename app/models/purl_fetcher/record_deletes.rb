module PurlFetcher
  class RecordDeletes
    attr_reader :druid, :latest_change
    def initialize(druid:, latest_change: nil)
      @druid = druid
      @latest_change = latest_change
    end

    def enqueue
      Settings.SERVICE_INDEXERS.each do |target|
        ##
        # The `target` here is an Array of configuration values, the first value
        # being the name of the target.
        Delayed::Job.enqueue(
          DiscoveryDispatcher::DeleteFromAllIndexesJob.new('delete', druid, target[0].to_s.downcase)
        )
      end
    end
  end
end
