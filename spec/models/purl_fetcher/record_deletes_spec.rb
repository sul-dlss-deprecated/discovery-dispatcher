require 'rails_helper'

describe PurlFetcher::RecordDeletes do
  describe '#initialize' do
    it 'requires a druid to be instantiated' do
      expect { described_class.new }.to raise_error ArgumentError
      expect(described_class.new(druid: 'abc123')).to be_an described_class
    end
  end
  describe '#enqueue' do
    context 'for all targets' do
      subject do
        described_class.new(druid: 'abc123')
      end
      it 'enqueue a delete job' do
        expect(Delayed::Job).to receive(:enqueue).with(DiscoveryDispatcher::IndexingJob.new('delete', 'abc123', 'searchworkspreview'))
        expect(Delayed::Job).to receive(:enqueue).with(DiscoveryDispatcher::IndexingJob.new('delete', 'abc123', 'searchworks'))
        subject.enqueue
      end
    end
  end
end
