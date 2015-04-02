describe DiscoveryDispatcher::IndexingJob do
  
  describe ".perform" do
    pending
  end

  describe ".get_target_url" do
    it "should return the url for the target that exists in the targets config" do
      Rails.configuration.target_urls = {"target1"=>{:url=>"http://target1-service"}}
      index_job = DiscoveryDispatcher::IndexingJob.new 
      url = index_job.get_target_url "target1", ""
      expect(url).to eq("http://target1-service")
    end
    
    it "should raise an error if the target doesn't exist" do
      Rails.configuration.target_urls = {"target1"=>{:url=>"http://target1-service"}}
      index_job = DiscoveryDispatcher::IndexingJob.new 
      expect{index_job.get_target_url "targetX", "ab123cd4567"}.to raise_error("Druid ab123cd4567 refers to target indexer targetX which is not registered within the application")
    end
  end

  describe ".get_method" do
    pending
  end
  
  describe ".get_subtarets_param" do
    pending
  end
end
