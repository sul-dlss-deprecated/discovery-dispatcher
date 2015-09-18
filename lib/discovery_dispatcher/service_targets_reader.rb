require 'singleton'
require 'json'

module DiscoveryDispatcher
  # It reads the service targets such as sw-indexing-service, revs-indexing-service
  # and makes sure the services are valid and up
  class ServiceTargetsReader
    include Singleton

    def read_service_targets
      services_uris = read_services_uris_file
      download_services_list(services_uris)
    end

    # @return a list of the services uris defined in config/targets/[RAILS_ENV].yml
    def read_services_uris_file
      YAML.load(File.new(Rails.root.join('config', 'targets', "#{Rails.env}.yml").to_s))
    end

    def download_services_list(services_uris)
      services_urls = {}
      unless services_uris
        Rails.logger.warn 'Service uris file is empty.'
        return services_urls
      end
      services_uris.each do |uri|
        begin
          response = RestClient.get "#{uri}/about/version.json"
          service_names = JSON.parse(response)['solr_cores'].keys
          service_names.each do |service_name|
            services_urls[service_name] = { 'url' => uri }
          end
        rescue => e
          Rails.logger.error "Problem in reading the solr cores from #{uri}.\n\n#{e.inspect}\n#{e.message}\n#{e.backtrace}"
        end
      end
      services_urls
    end
  end
end
