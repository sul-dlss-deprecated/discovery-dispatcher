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
        change_records = read_change_list
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
      merge_and_sort(change_records, delete_records)
    end

    # @return [Hash] a hash of the changed items between the start and end times, or {} if there are no records
    def read_change_list
      change_page = RestClient.get "#{Settings.PURL_FETCHER_URL}/docs/changes", params: { first_modified: @start_time, last_modified: @end_time, content_type: :json, accept: :json }
      return JSON.parse(change_page) if change_page.present?
      {}
    end

    # @return [Hash] a hash of the deleted items between the start and end times, or {} if there are no records
    def read_delete_list
      delete_page = RestClient.get "#{Settings.PURL_FETCHER_URL}/docs/deletes", params: { first_modified: @start_time, last_modified: @end_time, content_type: :json, accept: :json }
      return JSON.parse(delete_page) if delete_page.present?
      {}
    end

    # It merges both changed and deleted records in one list, and sorts the new list by last_modified time
    # @return [Array] a list of sorted/merged indexed and deleted records.
    def merge_and_sort(change_records, delete_records)
      all_records_list = []
      if change_records && change_records['changes']
        change_records['changes'].each do |change_record|
          if change_record['true_targets']
            change_record['true_targets'].each do |target|
              all_records_list.push(druid: change_record['druid'], latest_change: change_record['latest_change'], target: target, type: 'index')
            end
          end
          next unless change_record['false_targets']
          change_record['false_targets'].each do |target|
            all_records_list.push(druid: change_record['druid'], latest_change: change_record['latest_change'], target: target, type: 'delete')
          end
        end
      end
      if delete_records && delete_records['deletes']
        delete_records['deletes'].each do |delete_record|
          all_records_list.push(druid: delete_record['druid'], latest_change: delete_record['latest_change'], type: 'delete')
        end
      end

      all_records_list.sort_by { |item| [item[:latest_change], item[:type], item[:target]] } if all_records_list
    end
  end
end
