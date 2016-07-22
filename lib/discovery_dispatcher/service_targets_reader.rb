require 'singleton'
require 'json'

module DiscoveryDispatcher
  # It reads the service targets such as sw-indexing-service, revs-indexing-service
  # and makes sure the services are valid and up
  class ServiceTargetsReader
    include Singleton

    def targets_urls
      parse_service_json(Settings.SERVICE_TARGET_URLS)
    end

    def parse_service_json(services_uris)
      targets_urls = {}
      unless services_uris
        Rails.logger.warn 'Service uris are empty.'
        return targets_urls
      end
      services_uris.each do |uri|
        begin
          response = RestClient.get "#{uri}/about/version.json"
          solr_cores = JSON.parse(response)['solr_cores'].keys
          solr_cores.each do |solr_core|
            targets_urls[solr_core] = { 'url' => uri }
          end
        rescue => e
          Rails.logger.error "Problem in reading the solr cores from #{uri}.\n\n#{e.inspect}\n#{e.message}\n#{e.backtrace}"
        end
      end
      targets_urls
    end
  end
end
