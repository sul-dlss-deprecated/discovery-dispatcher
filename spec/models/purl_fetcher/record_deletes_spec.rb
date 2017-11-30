require 'rails_helper'

RSpec.describe PurlFetcher::RecordDeletes do
  describe '#initialize' do
    it 'requires a druid to be instantiated' do
      expect { described_class.new }.to raise_error ArgumentError
      expect(described_class.new(druid: 'abc123')).to be_an described_class
    end
  end
  describe '#fanout' do
    context 'for all targets' do
      subject do
        described_class.new(druid: 'abc123')
      end
      it 'enqueues delete jobs' do
        expect(DeleteFromAllIndexesJob).to receive(:perform_later).with('delete', 'abc123', 'searchworkspreview')
        expect(DeleteFromAllIndexesJob).to receive(:perform_later).with('delete', 'abc123', 'searchworks')
        expect(Rails.logger).to receive(:info).with(/Enqueued delete/)
        subject.fanout
      end
    end
  end
end
