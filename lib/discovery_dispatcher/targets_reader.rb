require 'singleton'
require 'json'

module DiscoveryDispatcher
  class TargetsReader
        include Singleton

    attr_accessor :target_urls
    
    def read_targets_from_service
      @target_urls={}
      services_uris = read_services_uris_file
      download_target_list(services_uris)
    end
    
    # @return a list of the services uris defined in config/targets/[RAILS_ENV].yml
    def read_services_uris_file       
      return YAML.load(File.new(Rails.root.join('config','targets', "#{Rails.env}.yml").to_s))
    end
       
    def download_target_list services_uris
      unless services_uris then
        Rails.logger.warn "Service uris file is empty."
        return
      end
      services_uris.each do |uri|
        begin
          response = RestClient.get "#{uri}/about/version.json"
          target_names = JSON.parse(response)["solr_cores"].keys
          app_name = JSON.parse(response)["app_name"]
          target_names.each do |target_name|
            @target_urls[target_name] = {"url"=>uri}
          end
        rescue =>e
          Rails.logger.error "Problem in reading the solr cores from #{uri}.\n\n#{e.inspect}\n#{e.message}\n#{e.backtrace}"
        end
      end
    end
    
  end
end