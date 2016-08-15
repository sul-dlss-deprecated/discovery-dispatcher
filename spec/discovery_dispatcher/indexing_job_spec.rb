describe DiscoveryDispatcher::IndexingJob do
  describe '.perform' do
    it 'performs the indexing process successfully' do
      VCR.use_cassette('index_xz404nk7341') do
        index_job = described_class.new('index', 'xz404nk7341', 'searchworkspreview')
        expect(Rails.logger).to receive(:debug).with(/Processing/).and_call_original
        expect(Rails.logger).to receive(:info).with(/Completed/).and_call_original
        index_job.perform
      end
    end
  end

  describe '.get_target_url' do
    it 'returns the url for the target that exists in the targets config' do
      index_job = described_class.new
      url = index_job.get_target_url 'searchworkspreview', ''
      expect(url).to eq('http://www.example-indexer.com')
    end

    it "raises an error if the target doesn't exist" do
      Rails.configuration.target_urls_hash = { 'target1' => { url: 'http://target1-service' } }
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
      index_job = DiscoveryDispatcher::IndexingJob.new
      actual_command = index_job.build_request_url('ab123cd4567', 'http://target1-service', 'target1')
      expect(actual_command).to eq('http://target1-service/items/ab123cd4567?subtargets%5Btarget1%5D=true')
    end

    it 'returns a request command based on the valid input and delete method ' do
      index_job = DiscoveryDispatcher::IndexingJob.new
      actual_command = index_job.build_request_url('ab123cd4567', 'http://target1-service', 'target2')
      expect(actual_command).to eq('http://target1-service/items/ab123cd4567?subtargets%5Btarget2%5D=true')
    end
  end
end
