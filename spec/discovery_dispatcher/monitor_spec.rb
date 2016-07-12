describe DiscoveryDispatcher::Monitor do
  describe '.run' do
    let(:records) { {} }
    let(:purlfetch) { double('purl-fetcher-reader', load_records: records) }
    it 'runs correctly when all data is available' do
      expect(DiscoveryDispatcher::PurlFetcherManager).to receive(:get_next_start_time).and_return('2012-01-01T12:00:00 -0800')
      expect(Time).to receive(:now).and_return('2014-01-01T12:00:00 -0800')
      expect(DiscoveryDispatcher::PurlFetcherReader).to receive(:new)
        .with('2012-01-01T12:00:00 -0800', '2014-01-01T12:00:00 -0800')
        .and_return(purlfetch)
      expect(DiscoveryDispatcher::IndexingJobManager).to receive(:enqueue_records).with(records)
      expect(DiscoveryDispatcher::PurlFetcherManager).to receive(:set_last_fetch_info).with('2014-01-01T12:00:00 -0800', records.length)
      described_class.run
    end
    it 'raises an error when start time is nil' do
      expect(DiscoveryDispatcher::PurlFetcherManager).to receive(:get_next_start_time).and_return(nil)
      expect(Time).to receive(:now).and_return(nil)
      expect(DiscoveryDispatcher::PurlFetcherReader).to receive(:new)
        .with(nil, nil).and_return(purlfetch)
      expect(DiscoveryDispatcher::IndexingJobManager).to receive(:enqueue_records).with(records)
      expect(DiscoveryDispatcher::PurlFetcherManager).to receive(:set_last_fetch_info).with(nil, 0)
      described_class.run
    end
    xit 'raises an error when end time is nil' do
      pending
    end
    xit 'raises an error when no records found' do
      pending
    end
    xit 'raises an error when set_last_fetch_info fails' do
      pending
    end
  end
end
