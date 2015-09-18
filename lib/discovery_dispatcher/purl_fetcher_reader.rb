require 'json'

module DiscoveryDispatcher
  # It reads the changed and deleted records from purl-fetcher
  class PurlFetcherReader
    # @param start_time [String] the start time for the period we need to read the records from
    # @param end_time [String] the end time for the period we need to read the records to
    def initialize(start_time, end_time)
      @start_time = start_time
      @end_time = end_time
    end

    # It reads and merges both of the changed and deleted records from purl-fetcher
    # @return a list of records sorted by last modified time
    def load_records
      begin
        index_records = read_index_list
      rescue => e
        message = "#{e.message}\n"
        e.backtrace.each { |l| message = "#{message}#{l}\n" }
        raise DiscoveryDispatcher::Errors::MissingPurlFetcherIndexPage.new(message)
      end

      begin
        delete_records = read_delete_list
      rescue => e
        message = "#{e.message}\n"
        e.backtrace.each { |l| message = "#{message}#{l}\n" }
        raise DiscoveryDispatcher::Errors::MissingPurlFetcherDeletePage.new(message)
      end
      all_records = merge_and_sort(index_records, delete_records)
    end

    # @return [Hash] a hash of the indexed items between the start and end times, or {} if there are no records
    def read_index_list
      index_page =  RestClient.get "#{Rails.configuration.purl_fetcher_url}/docs/changes", params: { first_modified: @start_time, last_modified: @end_time, content_type: :json, accept: :json }
      if index_page.present?
        return JSON.parse(index_page)
      else
        return {}
      end
    end

    # @return [Hash] a hash of the deleted items between the start and end times, or {} if there are no records
    def read_delete_list
      delete_page = RestClient.get "#{Rails.configuration.purl_fetcher_url}/docs/deletes", {:params => {:first_modified => @start_time, :last_modified => @end_time, :content_type => :json, :accept => :json}}
      if delete_page.present?
        return JSON.parse(delete_page)
      else
        return {}
      end
    end

    # It merges both indexed and deleted records in one list, and sorts the new list by last_modified time
    # @return [Array] a list of sorted/merged indexed and deleted records.
    def merge_and_sort(index_records, delete_records)
      all_records_list = []
      if index_records && index_records['changes']
        index_records['changes'].each do |index_record|
          if index_record['true_targets']
            index_record['true_targets'].each do |target|
              all_records_list.push(druid: index_record['druid'], latest_change: index_record['latest_change'], target: target, type: 'index')
            end
          end
          if index_record['false_targets']
            index_record['false_targets'].each do |target|
              all_records_list.push(druid: index_record['druid'], latest_change: index_record['latest_change'], target: target, type: 'delete')
            end
          end
        end
      end
      if delete_records && delete_records['deletes']
        delete_records['deletes'].each do |delete_record|
          all_records_list.push(druid: delete_record['druid'], latest_change: delete_record['latest_change'], type: 'delete')
        end
      end

      all_records_list.sort_by { |item| item[:latest_change] } if all_records_list
    end
  end
end
