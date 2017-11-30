require 'rails_helper'

RSpec.describe PurlFetcher::RecordChanges do
  describe '#initialize' do
    it 'requires a druid to be instantiated' do
      expect { described_class.new }.to raise_error ArgumentError
      expect(described_class.new(druid: 'abc123')).to be_an described_class
    end
  end
  describe '#fanout' do
    context 'true_targets' do
      subject do
        described_class.new(druid: 'abc123', true_targets: ['SearchWorks', 'Revs'])
      end
      it 'enqueues indexing jobs' do
        expect(IndexingJob).to receive(:perform_later).with('index', 'abc123', 'SearchWorks')
        expect(IndexingJob).to receive(:perform_later).with('index', 'abc123', 'Revs')
        expect(Rails.logger).to receive(:info).with(/Enqueued changes/)
        subject.fanout
      end
    end
    context 'false_targets' do
      subject do
        described_class.new(druid: 'abc123', false_targets: ['EarthWorks'])
      end
      it 'enqueues delete jobs' do
        expect(IndexingJob).to receive(:perform_later).with('delete', 'abc123', 'EarthWorks')
        expect(Rails.logger).to receive(:info).with(/Enqueued changes/)
        subject.fanout
      end
    end
  end
end
