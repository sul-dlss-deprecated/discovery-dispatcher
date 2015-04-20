module DiscoveryDispatcher
  class IndexingJob < Struct.new(:type, :druid, :target, :subtargets)
    def perform
      
      druid = druid.sub("druid:","")  
      target_url  = get_target_url target, druid
      method      = get_method type, druid   
      subtarets_param = get_subtarets_param subtargets
    
      request_command = "RestClient.#{method} \"#{target_url}/items/#{druid}#{subtarets_param}\", \"\""
      puts request_command
      begin
        eval(request_command)
      rescue => e
        raise "#{type} #{druid} with #{request_command} has an error.\n#{e.inspect}\n#{e.message}\n#{e.backtrace}"
      end
    end      
      
    def get_target_url target,druid
      target_urls_hash = Rails.configuration.target_urls
     # puts ">#{target}<"
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
    
    def get_subtarets_param subtargets
      subtarets_param = ""
      unless subtargets.nil? or subtargets.empty? then
        subtarets_param = "?"
      end
      return subtarets_param
    end
  end
end
