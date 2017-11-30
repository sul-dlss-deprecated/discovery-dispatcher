module PurlFetcher
  class RecordDeletes
    attr_reader :druid, :latest_change
    def initialize(druid:, latest_change: nil)
      @druid = druid
      @latest_change = latest_change
    end

    def fanout
      Settings.SERVICE_INDEXERS.each do |target|
        DeleteFromAllIndexesJob.perform_later('delete', druid, target_name(target))
      end
      Rails.logger.info "Enqueued delete jobs for #{druid}"
    end

    private

      ##
      # The `target` here is an Array of configuration values, the first value
      # being the name of the target.
      def target_name(target)
        target[0].to_s.downcase
      end
  end
end
