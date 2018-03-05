require 'rails_helper'

describe IndexingJob do
  describe '.perform' do
    it 'performs the indexing process successfully' do
      stub_request(:put, 'http://www.example-indexer.com/items/xz404nk7341/subtargets/SEARCHWORKSPREVIEW').
        to_return(status: 200)
      expect(Rails.logger).to receive(:info).with(/Completed.*type index/).and_call_original
      index_job = described_class.perform_now('index', 'xz404nk7341', 'searchworkspreview')
    end
    it 'logs errors in the indexing processings' do
      stub_request(:put, 'http://www.example-indexer.com/items/xz404nk7341/subtargets/SEARCHWORKSPREVIEW').
        to_return(status: 500)
      expect(Rails.logger).to receive(:error).with(/Cannot perform/).and_call_original
      expect { described_class.perform_now('index', 'xz404nk7341', 'searchworkspreview') }.to raise_error(RuntimeError, /index.*has an error/)
    end
    it 'short-circuits gracefully if the target is declared to be false' do
      allow(Settings).to receive(:SERVICE_INDEXERS).and_return({ 'TARGET1' => false })
      expect { described_class.perform_now('index', 'xz404nk7341', 'target1') }.not_to raise_error
    end
  end

  describe '.get_target_url' do
    it 'returns the url for the target that exists in the targets config' do
      index_job = described_class.new
      url = index_job.get_target_url 'searchworkspreview', ''
      expect(url).to eq('http://www.example-indexer.com')
    end

    it "returns nil if the target is defined as false" do
      allow(Settings).to receive(:SERVICE_INDEXERS).and_return({ 'TARGETX' => false })
      index_job = described_class.new
      expect(index_job.get_target_url 'targetX', 'ab123cd4567').to eq nil
    end

    it "raises an error if the target doesn't exist" do
      index_job = described_class.new
      expect { index_job.get_target_url 'targetX', 'ab123cd4567' }.to raise_error('Druid ab123cd4567 refers to target indexer targetX which is not registered within the application')
    end
  end

  describe '.get_method' do
    it 'returns put for index action' do
      index_job = described_class.new
      expect(index_job.get_method('index', '')).to eq('put')
    end
    it 'returns delete for delete action' do
      index_job = described_class.new
      expect(index_job.get_method('delete', '')).to eq('delete')
    end
    it 'raises an error for type other than index or delete' do
      index_job = described_class.new
      expect { index_job.get_method('other', 'ab123cd4567') }.to raise_error.with_message('Druid ab123cd4567 refers to action other which is not a vaild action, use index or delete')
    end
  end

  describe '.run_request' do
    let(:url) { 'http://www.example.com/items/xz404nk7341' }
    let(:connection) { instance_double(Faraday::Connection) }
    before do
      expect(Faraday).to receive(:new).with(url: url).and_return(connection)
    end
    it 'runs an index for a found purl page' do
      expect(connection).to receive(:put)
        .and_return(instance_double('Faraday::Response', status: 200))
      expect(subject.run_request('xz404nk7341', 'index', url)).to be nil
    end
    it 'runs a delete for a found purl page' do
      expect(connection).to receive(:delete)
        .and_return(instance_double('Faraday::Response', status: 200))
      expect(subject.run_request('xz404nk7341', 'delete', url)).to be nil
    end
    it 'raises an exception for not found purl with response 202' do
      expect(connection).to receive(:delete)
        .and_return(instance_double('Faraday::Response', status: 202))
      expect { subject.run_request('xz404nk7341', 'delete', url) }.to raise_error(RuntimeError)
    end
    it 'raises an exception with unfound host' do
      expect(connection).to receive(:put)
        .and_return(instance_double('Faraday::Response', status: 404))
      expect { subject.run_request('bb003xz2306', 'index', url) }.to raise_error(RuntimeError)
    end
  end

  describe '.build_request_url' do
    it 'returns a request command based on the valid input and put method ' do
      index_job = IndexingJob.new
      actual_command = index_job.build_request_url('ab123cd4567', 'http://target1-service', 'target1')
      expect(actual_command).to eq('http://target1-service/items/ab123cd4567/subtargets/TARGET1')
    end

    it 'returns a request command based on the valid input and delete method ' do
      index_job = IndexingJob.new
      actual_command = index_job.build_request_url('ab123cd4567', 'http://target1-service', 'target2')
      expect(actual_command).to eq('http://target1-service/items/ab123cd4567/subtargets/TARGET2')
    end
  end
end
