require 'json'

describe DiscoveryDispatcher::PurlFetcherReader do
  describe '.load_records' do
    pending
  end

  describe '.read_index_list' do
    it 'should return a JSON formatted hash' do
      reader = DiscoveryDispatcher::PurlFetcherReader.new('', '')
      index_page = '{"changes":[{"druid":"druid:bb298yx8728","latest_change":"2015-07-03T01:00:57.046Z","true_targets":["revs_stage"],"false_targets":["Atago","Robot_testing_feb_5_2015"]}, {"druid":"druid:bx498hg0161","latest_change":"2015-09-01T17:00:11.869Z","true_targets":["SearchWorks","sw_stage"],"false_targets":["Sw-stage"]}]}'
      allow(RestClient).to receive(:get).and_return(index_page)
      expect(reader.read_index_list).to eq(JSON.parse(index_page))
    end

    it 'should return an empty hash when no changes returned from purl-fetcher' do
      reader = DiscoveryDispatcher::PurlFetcherReader.new('', '')
      index_page = ''
      allow(RestClient).to receive(:get).and_return(index_page)
      expect(reader.read_index_list).to eq({})
    end
  end

  describe '.read_delete_list' do
    it 'should return a JSON formatted hash' do
      reader = DiscoveryDispatcher::PurlFetcherReader.new('', '')
      delete_page = '{"deletes":[{"druid":"druid:dw158ws3808","latest_change":"2015-06-26T00:55:05.925Z"},{"druid":"druid:mw708hb9804","latest_change":"2015-07-21T20:10:06.016Z"},{"druid":"druid:gq647pk5594","latest_change":"2015-08-21T00:05:06.556Z"},{"druid":"druid:gq774kt0366","latest_change":"2015-08-26T00:05:06.888Z"},{"druid":"druid:cb781mj1863","latest_change":"2015-08-26T00:05:06.888Z"},{"druid":"druid:xk117ff1564","latest_change":"2015-08-26T00:05:06.888Z"},{"druid":"druid:kb492rx4952","latest_change":"2015-09-16T20:55:06.803Z"},{"druid":"druid:sc897ds8067","latest_change":"2015-09-16T20:55:06.803Z"},{"druid":"druid:wr005wn5739","latest_change":"2015-09-16T21:50:05.634Z"}]}'
      allow(RestClient).to receive(:get).and_return(delete_page)
      expect(reader.read_delete_list).to eq(JSON.parse(delete_page))
    end

    it 'should return an empty hash when no changes returned from purl-fetcher' do
      reader = DiscoveryDispatcher::PurlFetcherReader.new('', '')
      delete_page = ''
      allow(RestClient).to receive(:get).and_return(delete_page)
      expect(reader.read_delete_list).to eq({})
    end
  end

  describe '.merge_and_sort' do
    it 'should return a sorted/merged list for index and delete' do
      reader = DiscoveryDispatcher::PurlFetcherReader.new('', '')

      index_hash = '{"changes":[ {"druid":"druid:aa111aa1111","latest_change":"2014-12-20T21:03:32Z","true_targets":["Searchwork","Revs"],"false_targets":["Sw_stage"]},  {"druid":"druid:bb111bb1111","latest_change":"2014-12-15T10:03:32Z","true_targets":["Revs"]}]}'
      delete_hash = '{"deletes":[{"druid":"druid:aa111aa1111","latest_change":"2014-12-15T21:03:32Z"},{"druid":"druid:bb111bb1111","latest_change":"2014-12-10T21:03:32Z"} ]}'
      merged_hash = reader.merge_and_sort(JSON.parse(index_hash), JSON.parse(delete_hash))

      expect(merged_hash.length).to eq(6)
      expect(merged_hash[0]).to eq(druid: 'druid:bb111bb1111', latest_change: '2014-12-10T21:03:32Z', type: 'delete')
      expect(merged_hash[1]).to eq(druid: 'druid:bb111bb1111', latest_change: '2014-12-15T10:03:32Z', target: 'Revs', type: 'index')
      expect(merged_hash[2]).to eq(druid: 'druid:aa111aa1111', latest_change: '2014-12-15T21:03:32Z', type: 'delete')
      expect(merged_hash[3]).to eq(druid: 'druid:aa111aa1111', latest_change: '2014-12-20T21:03:32Z', target: 'Sw_stage', type: 'delete')
      expect(merged_hash[4]).to eq(druid: 'druid:aa111aa1111', latest_change: '2014-12-20T21:03:32Z', target: 'Revs', type: 'index')
      expect(merged_hash[5]).to eq(druid: 'druid:aa111aa1111', latest_change: '2014-12-20T21:03:32Z', target: 'Searchwork', type: 'index')
    end

    it 'should return an empty list for empty index and delete' do
      reader = DiscoveryDispatcher::PurlFetcherReader.new('', '')
      merged_hash = reader.merge_and_sort({}, {})
      expect(merged_hash).to eq([])
    end

    it 'should return a sorted list for  index hash with items and empty delete hash' do
      index_hash = '{"changes":[ {"druid":"druid:aa111aa1111","latest_change":"2014-12-20T21:03:32Z","true_targets":["Searchwork","Revs"],"false_targets":["Sw_stage"]},  {"druid":"druid:bb111bb1111","latest_change":"2014-12-15T10:03:32Z","true_targets":["Revs"]}]}'
      reader = DiscoveryDispatcher::PurlFetcherReader.new('', '')
      merged_hash = reader.merge_and_sort(JSON.parse(index_hash), {})
      expect(merged_hash.length).to eq(4)
      expect(merged_hash[0]).to eq(druid: 'druid:bb111bb1111', latest_change: '2014-12-15T10:03:32Z', target: 'Revs', type: 'index')
      expect(merged_hash[1]).to eq(druid: 'druid:aa111aa1111', latest_change: '2014-12-20T21:03:32Z', target: 'Sw_stage', type: 'delete')
      expect(merged_hash[2]).to eq(druid: 'druid:aa111aa1111', latest_change: '2014-12-20T21:03:32Z', target: 'Revs', type: 'index')
      expect(merged_hash[3]).to eq(druid: 'druid:aa111aa1111', latest_change: '2014-12-20T21:03:32Z', target: 'Searchwork', type: 'index')
    end

    it 'should return a sorted list for empty index hash and delete hash with items' do
      delete_hash = '{"deletes":[{"druid":"druid:aa111aa1111","latest_change":"2014-12-15T21:03:32Z"},{"druid":"druid:bb111bb1111","latest_change":"2014-12-10T21:03:32Z"} ]}'
      reader = DiscoveryDispatcher::PurlFetcherReader.new('', '')
      merged_hash = reader.merge_and_sort({}, JSON.parse(delete_hash))
      expect(merged_hash.length).to eq(2)
      expect(merged_hash[0]).to eq(druid: 'druid:bb111bb1111', latest_change: '2014-12-10T21:03:32Z', type: 'delete')
      expect(merged_hash[1]).to eq(druid: 'druid:aa111aa1111', latest_change: '2014-12-15T21:03:32Z', type: 'delete')
    end
  end
end
