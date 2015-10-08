describe DiscoveryDispatcher::PurlFetcherManager do
  describe '.get_next_start_time' do
    before :each do
      ReaderLogRecords.delete_all
    end

    it 'should return the next start time' do
      ReaderLogRecords.create(last_read_time: '2010-01-01T12:00:00 -0800', record_count: 1)
      ReaderLogRecords.create(last_read_time: '2011-01-01T12:00:00 -0800', record_count: 1)
      ReaderLogRecords.create(last_read_time: '2012-01-01T12:00:00 -0800', record_count: 1)

      start_time = DiscoveryDispatcher::PurlFetcherManager.get_next_start_time
      expect(start_time).to eq('2012-01-01T11:58:00-08:00')
    end

    it 'should return 1970 as the start time for empty table' do
      start_time = DiscoveryDispatcher::PurlFetcherManager.get_next_start_time
      expect(start_time).to eq('1970-01-01T12:00:00-08:00')
    end

    after :each do
      ReaderLogRecords.delete_all
    end
  end

  describe '.set_last_fetch_info' do
    before :each do
      ReaderLogRecords.delete_all
    end

    it 'should insert the last time and the count' do
      DiscoveryDispatcher::PurlFetcherManager.set_last_fetch_info Time.parse('2015-01-01T12:00:00 -0800').to_s, 5
      last_id = ReaderLogRecords.maximum(:id)
      record = ReaderLogRecords.find last_id
      expect(record.last_read_time).to eq(Time.parse('2015-01-01T12:00:00 -0800'))
      expect(record.record_count).to eq(5)
    end
    after :each do
      ReaderLogRecords.delete_all
    end
  end
end
