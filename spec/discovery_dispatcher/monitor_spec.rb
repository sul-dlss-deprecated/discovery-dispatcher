describe DiscoveryDispatcher::Monitor do
  describe '.run' do
    let(:records) { {} }
    let(:purlfetch) { double('purl-fetcher-reader', load_records: records) }
    it 'runs correctly when all data is available' do
      start_time='2012-01-01T12:00:00 -0800'
      end_time='2014-01-01T12:00:00 -0800'
      expect(DiscoveryDispatcher::PurlFetcherManager).to receive(:next_start_time).and_return(start_time)
      expect(Time).to receive(:now).and_return(end_time)
      expect(DiscoveryDispatcher::PurlFetcherReader).to receive(:new).with(start_time, end_time).and_return(purlfetch)
      expect(DiscoveryDispatcher::IndexingJobManager).to receive(:enqueue_records).with(records)
      expect(DiscoveryDispatcher::PurlFetcherManager).to receive(:set_last_fetch_info).with(end_time, records.length)
      expect { described_class.run }.not_to raise_error
    end
    it 'returns an exception if one of the calls rails' do
      allow(DiscoveryDispatcher::IndexingJobManager).to receive(:enqueue_records).with(records).and_return(Exception.new)
      expect { described_class.run }.to raise_error(DiscoveryDispatcher::Errors::MissingPurlFetcherIndexPage)
    end
    xit 'raises an error when no records found' do
      pending
    end
    xit 'raises an error when set_last_fetch_info fails' do
      pending
    end
  end
end
