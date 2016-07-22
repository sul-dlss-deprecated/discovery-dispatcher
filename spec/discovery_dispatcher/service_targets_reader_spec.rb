describe DiscoveryDispatcher::ServiceTargetsReader do
  describe '.parse_service_json' do
    it 'reads the keys from the services uris ' do
      VCR.use_cassette('target_localhost') do
        targets_urls = described_class.instance.parse_service_json(['http://localhost:3000'])
        expect(targets_urls).to eq('Searchworks' => { 'url' => 'http://localhost:3000' },
                                   'Searchworks:stage' => { 'url' => 'http://localhost:3000' },
                                   'Searchworks:preview' => { 'url' => 'http://localhost:3000' })
      end
    end
    it 'recovers from service uri is not available' do
      VCR.use_cassette('target_localhost_notfound') do
        targets_urls = described_class.instance.parse_service_json(['http://localhost:3000'])
        expect(targets_urls).to eq({})
      end
    end
    it 'returns if services uris equals false' do
      targets_urls = described_class.instance.parse_service_json(false)
      expect(targets_urls).to eq({})
    end
  end
end
