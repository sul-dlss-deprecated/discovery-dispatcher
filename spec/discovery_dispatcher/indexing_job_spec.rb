describe DiscoveryDispatcher::IndexingJob do
  describe '.perform' do
    it 'performs the indexing process successfully' do
      VCR.use_cassette('index_xz404nk7341') do
        index_job = described_class.new('index', 'xz404nk7341', 'target1')
        Rails.configuration.target_urls_hash = { 'target1' => { 'url' => 'http://localhost:3000' } }
        expect_any_instance_of(DiscoveryDispatcher::IndexingJob).to receive('build_request_url').with('xz404nk7341', 'http://localhost:3000', 'target1').and_return('RestClient.put "http://localhost:3000/items/xz404nk7341?target1", ""')
        expect_any_instance_of(DiscoveryDispatcher::IndexingJob).to receive('run_request').with('xz404nk7341', 'index', 'RestClient.put "http://localhost:3000/items/xz404nk7341?target1", ""')
        expect(Rails.logger).to receive(:debug).with(/Processing/).and_call_original
        expect(Rails.logger).to receive(:info).with(/Completed/).and_call_original
        index_job.perform
      end
    end
  end

  describe '.get_target_url' do
    it 'returns the url for the target that exists in the targets config' do
      Rails.configuration.target_urls_hash = { 'target1' => { 'url' => 'http://target1-service' } }
      index_job = described_class.new
      url = index_job.get_target_url 'target1', ''
      expect(url).to eq('http://target1-service')
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
    it 'runs an index for a found purl page' do
      VCR.use_cassette('index_xz404nk7341') do
        index_job = DiscoveryDispatcher::IndexingJob.new
        url = 'http://localhost:3000/items/xz404nk7341'
        expect(index_job.run_request('xz404nk7341', 'index', url)).to be nil
      end
    end
    it 'runs a delete for a found purl page' do
      VCR.use_cassette('index_xz404nk7341') do
        index_job = DiscoveryDispatcher::IndexingJob.new
        url = 'http://localhost:3000/items/xz404nk7341'
        expect(index_job.run_request('xz404nk7341', 'delete', url)).to be nil
      end
    end
    it 'raises an exception for not found purl with response 202' do
      VCR.use_cassette('index_bb003xz2306_nopurl') do
        index_job = DiscoveryDispatcher::IndexingJob.new
        url = 'http://localhost:3000/items/bb003xz2306'
        expect { index_job.run_request('bb003xz2306', 'index', url) }.to raise_error(RuntimeError)
      end
    end
    it 'raises an exception with unfound host' do
      VCR.use_cassette('index_bb003xz2306_nohost') do
        index_job = DiscoveryDispatcher::IndexingJob.new
        url = 'http://target-service/items/bb003xz2306'
        expect { index_job.run_request('bb003xz2306', 'index', url) }.to raise_error(RuntimeError)
      end
    end
  end

  describe '.build_request_url' do
    it 'returns a request command based on the valid input and put method ' do
      index_job = DiscoveryDispatcher::IndexingJob.new
      actual_command = index_job.build_request_url('ab123cd4567', 'http://target1-service', 'target1')
      expect(actual_command).to eq('http://target1-service/items/ab123cd4567?solr_target%5B%5D=target1')
    end

    it 'returns a request command based on the valid input and delete method ' do
      index_job = DiscoveryDispatcher::IndexingJob.new
      actual_command = index_job.build_request_url('ab123cd4567', 'http://target1-service', 'target2')
      expect(actual_command).to eq('http://target1-service/items/ab123cd4567?solr_target%5B%5D=target2')
    end
  end
end
