module DiscoveryDispatcher
  # IndexingJob represents a single job managed by Delayed_job
  # @example Enqueue a job into Delayed job queue
  #  Delayed::Job.enqueue(IndexingJob.new(record[:type], record[:druid], target ))
  #
  class IndexingJob < Struct.new(:type, :druid_id, :target)
    def perform
      Rails.logger.debug "Processing #{druid_id} for target #{target}"
      druid = druid_id.gsub('druid:', '')
      target_url  = get_target_url target, druid
      method      = get_method type, druid

      request_command = build_request_command(druid, method, target_url, target)
      run_request_command(druid, type, request_command)

      # Request went successfully
      Rails.logger.debug "Completing #{druid_id} for target #{target}"
    end

    # @param druid [String] represents the druid on the form of ab123cd4567
    # @param method [String] it may be put or delete
    # @param target_url [String] the url for the indexing service
    # @param solr_target [Array] solr target for solr core
    # @return [String] RestClient request command
    def build_request_command(druid, method, target_url, solr_target)
      solr_target = Array(solr_target)
      request_command = "RestClient.#{method} \"#{target_url}/items/#{druid}?#{solr_target.to_query('solr_target')}\""
      request_command = "#{request_command}, \"\"" if method == 'put'
      request_command
    end

    # It runs the request command
    # @param druid [String] represents the druid on the form of ab123cd4567
    # @param type [String] index or delete
    # @param request_command [String] RestClient request command
    def run_request_command(druid, type, request_command)
      response = nil
      begin
        response = eval(request_command)
      rescue => e # An exception happened during the request
        raise "#{type} #{druid} with #{request_command} has an error.\n#{e.inspect}\n#{e.message}\n#{e.backtrace}"
      end

      # The request doesn't raise an exception but it doesn't return data
      raise "#{type} #{druid} with #{request_command} has an error." if response.nil?

      # The request return with anything other than 200, so it is a problem
      raise "#{type} #{druid} with #{request_command} has an error.\n#{response.code}\n\n#{response.inspect}" if response.code != 200
    end

    # It gets the indexing service url based on the target name
    def get_target_url(target, druid)
      target_urls_hash = Rails.configuration.target_urls_hash
      if target_urls_hash.include?(target)
        return target_urls_hash[target]['url']
      else
        raise "Druid #{druid} refers to target indexer #{target} which is not registered within the application"
      end
    end

    def get_method(type, druid)
      if type == 'index'
        return 'put'
      elsif type == 'delete'
        return 'delete'
      else
        raise "Druid #{druid} refers to action #{type} which is not a vaild action, use index or delete"
      end
    end
  end
end
