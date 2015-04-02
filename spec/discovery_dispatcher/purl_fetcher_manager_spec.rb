describe DiscoveryDispatcher::PurlFetcherManager do
  
  describe ".get_next_start_time" do
    before :all do
    end
    
    it "should return the next start time" do
      ReaderLogRecords.create(last_read_time: "2010-01-01T12:00:00",record_count: 1)
      start_time = DiscoveryDispatcher::PurlFetcherManager.get_next_start_time
      puts start_time.in_time_zone('Eastern Time (US & Canada)')
      ReaderLogRecords.delete_all
    end
  end
  
  describe ".set_last_fetch_info" do
    pending
  end
  
end