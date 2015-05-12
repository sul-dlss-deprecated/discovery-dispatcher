require 'json'

module DiscoveryDispatcher
  
  # It reads the indexed/deleted records from purl-fetcher
  class PurlFetcherReader
    
    # @param start_time [String] the start time for the period we need to read the records from
    # @param end_time [String] the end time for the period we need to read the records to
    def initialize(start_time, end_time)
      @start_time = start_time
      @end_time = end_time
    end
    
    # It reads and merge both of the indexing and deleted records from purl-fetcher
    # @return a list of records sorted by last modified time
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
    
    # @return [Hash] a hash of the indexed items between the start and end times, or {} if ther's no records
    def read_index_list
      index_page =  RestClient.get "#{Rails.configuration.purl_fetcher_url}/docs/changes", {:params => {:first_modified => @start_time, :last_modified => @end_time, :content_type => :json, :accept => :json}}
      if index_page.present? then
        return JSON.parse(index_page)
      else
        return {}
      end
    end
    
    # @return [Hash] a hash of the deleted items between the start and end times, or {} if ther's no records
    def read_delete_list
    #  delete_page = RestClient.get "#{Rails.configuration.purl_fetcher_url}/docs/deletes", {:params => {:first_modified => @start_time, :last_modified => @end_time, :content_type => :json, :accept => :json}}
      delete_page = nil
      if delete_page.present? then
        return JSON.parse(delete_page) 
      else
        return {}
      end
    end
    
    # It merges both indexed and deleted records in one list, and sort the new list by last_modified time
    # @return [Array] a list of sorted/merged indexed and deleted records.
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