describe DiscoveryDispatcher::TargetsReader do
  
  before :all do
    @fixtures = 'spec/fixtures/'
  end
  
  describe ".read_targets_from_service" do
    pending
  end

  describe ".read_services_uris_file" do
    before :all do
      @base_rails_env = Rails.env
      FileUtils.cp "#{@fixtures}test_env.yml", "config/targets/test_env.yml"
      FileUtils.cp "#{@fixtures}empty_env.yml", "config/targets/empty_env.yml"
    end
    
    it "raises an error if the file doesn't exist" do
       Rails.env = "nothing"
       expect{DiscoveryDispatcher::TargetsReader.instance.read_services_uris_file}.to raise_error
    end
    
    it "returns a list of services urls" do
      Rails.env = "test_env"
      services_urls = DiscoveryDispatcher::TargetsReader.instance.read_services_uris_file
      expect(services_urls).to eq(["http://system1.example.org","http://system2.example.org"])
    end
 
    it "returns false for empty file" do
      Rails.env = "empty_env"
      services_urls = DiscoveryDispatcher::TargetsReader.instance.read_services_uris_file
      expect(services_urls).to be false
    end
    
    after :all do
      Rails.env = @base_rails_env
    end
  end

  describe ".download_target_list" do
    
    it "reads the keys from the services uris " do
      VCR.use_cassette("target_localhost") do
        services_uris = ["http://localhost:3000"] 
        target_urls = DiscoveryDispatcher::TargetsReader.instance.download_target_list(services_uris) 
        expect(target_urls).to eq({"target1"=>{"url"=>"http://localhost:3000"}, "target2"=>{"url"=>"http://localhost:3000"}})
      end
    end
    it "recovers from service uri is not available" do
      VCR.use_cassette("target_localhost_notfound") do
        services_uris = ["http://localhost:3000"] 
        target_urls = DiscoveryDispatcher::TargetsReader.instance.download_target_list(services_uris)
        expect(target_urls).to eq({})
      end
    end
    it "returns if services uris equals false" do
      target_urls = DiscoveryDispatcher::TargetsReader.instance.download_target_list(false) 
      expect(target_urls).to eq({})
    end
    
  end
  
  after :all do
    FileUtils.rm  "config/targets/test_env.yml"
    FileUtils.rm  "config/targets/empty_env.yml"
  end
end
