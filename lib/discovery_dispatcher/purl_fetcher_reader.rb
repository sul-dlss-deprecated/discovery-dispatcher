require 'json'

module DiscoveryDispatcher
  class PurlFetcherReader
    
    def initialize(start_time, end_time)
      @start_time = start_time
      @end_time = end_time
    end
    
    def load_records
      begin
        index_records = read_index_list
      rescue =>e
        message = "#{e.message}\n"
        e.backtrace.each { |l| message = "#{message}#{l}\n"}
        raise  DiscoveryDispatcher::Errors::MissingPurlFetcherIndexPage.new(message )
      end

      begin
        delete_records = read_delete_list       
      rescue =>e
        message = "#{e.message}\n"
        e.backtrace.each { |l| message = "#{message}#{l}\n"}
        raise  DiscoveryDispatcher::Errors::MissingPurlFetcherDeletePage.new(message )
      end

      all_records = merge_and_sort(index_records, delete_records)
    end
    
    def read_index_list
      index_page =  RestClient.get "#{Rails.configuration.purl_fetcher_url}/docs/changes", {:params => {:first_modified => @start_time, :last_modified => @end_time, :content_type => :json, :accept => :json}}
      if index_page.present? then
        return JSON.parse(index_page)
      else
        return {}
      end
    end
    
    def read_delete_list
    #  delete_page = RestClient.get "#{Rails.configuration.purl_fetcher_url}/docs/deletes", {:params => {:first_modified => @start_time, :last_modified => @end_time, :content_type => :json, :accept => :json}}
      delete_page = nil
      if delete_page.present? then
        return JSON.parse(delete_page) 
      else
        return {}
      end
    end
    
    def merge_and_sort(index_records, delete_records)
      all_records_list=[]
      if not(index_records.nil?) and index_records.include?("changes") and not(index_records["changes"].empty?)
        index_records["changes"].each do |index_record| 
          all_records_list.push( index_record.update( {:type=>"index" }))
        end 
      end
      if not(delete_records.nil?) and delete_records.include?("deletes") and not(delete_records["deletes"].empty?)
        delete_records["deletes"].each do |delete_record| 
          all_records_list.push( delete_record.update( {:type=>"delete" }))
        end 
      end 
      
      return all_records_list.sort_by{ |item| item["latest_change"]}
    end
  end
end