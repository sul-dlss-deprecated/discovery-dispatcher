class IndexingJob < ActiveJob::Base
  queue_as :default

  def perform(type, druid_id, target)
    Rails.logger.debug { "Processing #{druid_id} for target #{target}" }
    elapsed = Benchmark.realtime do
      druid = druid_id.gsub('druid:', '')
      target_url  = get_target_url target, druid
      return unless target_url

      validate_method! type, druid

      url = build_request_url(druid, target_url, target)
      run_request(druid, type, url)
    end
    # Request went successfully
    Rails.logger.info "Completed #{druid_id} for target #{target} of type #{type} in #{sprintf('%0.4f', elapsed)}s"
  rescue => e
    Rails.logger.error "Cannot perform job on #{druid_id} for target #{target} of type #{type} in #{e.message}"
    raise
  end

  ##
  # By convention we are using settings on sw-indexer that specify subtargets
  # in all caps (thus the target upcase).
  # @param druid [String] represents the druid on the form of ab123cd4567
  # @param target_url [String] the url for the indexing service
  # @param solr_target [String] solr target for solr core
  # @return [String] RestClient request command
  def build_request_url(druid, target_url, solr_target)
    "#{target_url}/items/#{druid}/subtargets/#{solr_target.upcase}"
  end

  # It runs the request command
  # @param druid [String] represents the druid on the form of ab123cd4567
  # @param type [String] index or delete
  # @param request_command [String] RestClient request command
  def run_request(druid, type, request_url)
    response = nil
    begin
      conn = Faraday.new(url: request_url)
      if type == 'index'
        response = conn.put do |request|
          request.body = ''
        end
      else
        response = conn.delete
      end
      response
    rescue => e # An exception happened during the request
      raise "#{type} #{druid} with #{request_url} has an error.\n#{e.inspect}\n#{e.message}\n#{e.backtrace}"
    end

    # The request doesn't raise an exception but it doesn't return data
    fail "#{type} #{druid} with #{request_url} has an error." if response.nil?

    # The request return with anything other than 2xx, so it is a problem
    fail "#{type} #{druid} with #{request_url} has an error.\n#{response.status}\n\n#{response.inspect}" unless response.success?
  end

  # It gets the indexing service url based on the target name
  def get_target_url(target, druid)
    return Settings.SERVICE_INDEXERS[target.upcase].URL if Settings.SERVICE_INDEXERS[target.upcase]
    return if Settings.SERVICE_INDEXERS[target.upcase] == false
    raise "Druid #{druid} refers to target indexer #{target} which is not registered within the application"
  end

  def validate_method!(type, druid)
    return 'put' if type == 'index'
    return 'delete' if type == 'delete'
    raise "Druid #{druid} refers to action #{type} which is not a vaild action, use index or delete"
  end

end
