require 'rails_helper'

describe PurlFetcher::RecordChanges do
  describe '#initialize' do
    it 'requires a druid to be instantiated' do
      expect { described_class.new }.to raise_error ArgumentError
      expect(described_class.new(druid: 'abc123')).to be_an described_class
    end
  end
  describe '#enqueue' do
    context 'true_targets' do
      subject do
        described_class.new(druid: 'abc123', true_targets: ['SearchWorks', 'Revs'])
      end
      it 'are enqueued' do
        expect(Delayed::Job).to receive(:enqueue).with(DiscoveryDispatcher::IndexingJob.new('index', 'abc123', 'SearchWorks'))
        expect(Delayed::Job).to receive(:enqueue).with(DiscoveryDispatcher::IndexingJob.new('index', 'abc123', 'Revs'))
        subject.enqueue
      end
    end
    context 'false_targets' do
      subject do
        described_class.new(druid: 'abc123', false_targets: ['EarthWorks'])
      end
      it 'are enqueued' do
        expect(Delayed::Job).to receive(:enqueue).with(DiscoveryDispatcher::IndexingJob.new('delete', 'abc123', 'EarthWorks'))
        subject.enqueue
      end
    end
  end
end
