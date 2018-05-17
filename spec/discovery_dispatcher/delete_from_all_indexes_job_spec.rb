require 'rails_helper'

describe DeleteFromAllIndexesJob do
  describe '.perform' do
    it 'performs the indexing process successfully' do
      stub_request(:delete, 'http://example.com/indexer/items/xz404nk7341').
        to_return(status: 200)
      allow(Rails.logger).to receive(:info).and_call_original
      expect(Rails.logger).to receive(:info).with(/Completed.*type delete/).ordered.and_call_original
      described_class.perform_now('delete', 'xz404nk7341', 'searchworkspreview')
    end
  end
  describe '.build_request_url' do
    it 'builds a URL that references the base_indexer v3 api /items/:druid path' do
      expect(subject.build_request_url('ab123cd4567', 'http://example.com', ''))
        .to eq 'http://example.com/items/ab123cd4567'
    end
  end
  describe '.run_request' do
    let(:url) { 'http://example.com/items/xz404nk7341' }
    let(:connection) { instance_double(Faraday::Connection) }
    before do
      expect(Faraday).to receive(:new).with(url: url).and_return(connection)
    end
    it 'runs a delete for a found purl page' do
      expect(connection).to receive(:delete)
        .and_return(instance_double('Faraday::Response', success?: true))
      expect(subject.run_request('xz404nk7341', 'delete', url)).to be nil
    end
    it 'raises an exception for not found purl' do
      expect(connection).to receive(:delete)
        .and_return(instance_double('Faraday::Response', success?: false, status: 500))
      expect { subject.run_request('xz404nk7341', 'delete', url) }.to raise_error(RuntimeError)
    end
  end
end
