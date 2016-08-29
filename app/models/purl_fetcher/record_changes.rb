module PurlFetcher
  class RecordChanges
    attr_reader :druid, :latest_change, :true_targets, :false_targets
    def initialize(druid:, latest_change: nil, collections: [], true_targets: [], false_targets: [])
      @druid = druid
      @latest_change = latest_change
      @collections = collections
      @true_targets = true_targets
      @false_targets = false_targets
    end

    def enqueue
      true_targets.each do |true_target|
        IndexingJob.perform_later('index', druid, true_target)
      end
      false_targets.each do |false_target|
        IndexingJob.perform_later('delete', druid, false_target)
      end
      Rails.logger.info "Enqueued changes jobs for #{druid}"
    end
  end
end
