module DiscoveryDispatcher
  class IndexingJob < Struct.new(:type, :druid_id, :target)
    
    def perform
      Rails.logger.debug "Processing #{druid_id} for target #{target}"
      druid = druid_id.gsub("druid:","")  
      target_url  = get_target_url target, druid
      method      = get_method type, druid   

      request_command = build_request_command(druid, method, target_url)
      run_request_command(druid, type, request_command)
      
      # Request went successfully
      Rails.logger.debug "Completing #{druid_id} for target #{target}"
    end      
    
    def build_request_command(druid, method, target_url)
      request_command = "RestClient.#{method} \"#{target_url}/items/#{druid}\""
      request_command = "#{request_command}, \"\"" if method == "post"
      return request_command
    end
    
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
    
    def get_target_url target,druid
      target_urls_hash = DiscoveryDispatcher::TargetsReader.instance.target_urls
      if target_urls_hash.include?(target) then
        return target_urls_hash[target]["url"]
      else
        raise "Druid #{druid} refers to target indexer #{target} which is not registered within the application"
      end        
    end
    
    def get_method type, druid 
      if type == "index" then
        return "post"
      elsif type == "delete" then
        return "delete" 
      else
        raise "Druid #{druid} refers to action #{type} which is not a vaild action, use index or delete"
      end
    end
    
  end
end