describe DiscoveryDispatcher::IndexingJobManager do
  
  describe ".enqueue_records" do
    pending
  end

  describe ".enqueue_delete_record" do
    before :each do
      Delayed::Job.delete_all
    end
    
    it "enqueues the record with all available targets" do
      Delayed::Job.delete_all
      record={}
      record[:type]="delete"
      record[:druid]="ab123cd4567"
      Rails.configuration.targets_url_hash={"t_target1"=>{"url"=>"url1"},"t_target2"=>{"url"=>"url2"}}
      DiscoveryDispatcher::IndexingJobManager.enqueue_delete_record record
     
    end
    
    after :each do
      Delayed::Job.delete_all
    end
  end

  describe ".enqueue_index_record" do
    before :each do
      Delayed::Job.delete_all
    end
    it "doesn't index any record for record with empty targets" do
      Delayed::Job.delete_all
      record={}
      record[:true_targets] = []
      record[:false_targets] =[]
      DiscoveryDispatcher::IndexingJobManager.enqueue_index_record record
      expect(Delayed::Job.all.size).to eq(0) 
    end
    it "enqueues one job for record with 1 target" do
      Delayed::Job.delete_all
      record={}
      record[:type]="index"
      record[:druid]="ab123cd4567"
      record[:true_targets] = ["target1"]
      record[:false_targets] =[]
      DiscoveryDispatcher::IndexingJobManager.enqueue_index_record record
      expect(Delayed::Job.all.size).to eq(1) 
      expect(Delayed::Job.last.handler).to eq("--- !ruby/struct:DiscoveryDispatcher::IndexingJob\ntype: index\ndruid_id: ab123cd4567\ntarget: target1\n")
    end
    it "enques two jobs for record with 2 target" do
      Delayed::Job.delete_all
      record={}
      record[:type]="index"
      record[:druid]="ab123cd4567"
      record[:true_targets] = ["target1"]
      record[:false_targets] =["target2"]
      DiscoveryDispatcher::IndexingJobManager.enqueue_index_record record
      expect(Delayed::Job.all.size).to eq(2) 
      
      last_id = Delayed::Job.last.id
      expect(Delayed::Job.find(last_id-1).handler).to eq("--- !ruby/struct:DiscoveryDispatcher::IndexingJob\ntype: index\ndruid_id: ab123cd4567\ntarget: target1\n")
      expect(Delayed::Job.find(last_id).handler).to eq("--- !ruby/struct:DiscoveryDispatcher::IndexingJob\ntype: index\ndruid_id: ab123cd4567\ntarget: target2\n")
    end
    
    after :each do
      Delayed::Job.delete_all
    end

  end
  
  describe ".get_target_url" do
    pending 
  end
  
  describe ".merge_and_uniq_targets" do
    it "returns empty list for empty or nil inputs" do
      expect(DiscoveryDispatcher::IndexingJobManager.merge_and_uniq_targets([],[])).to eq([])
      expect(DiscoveryDispatcher::IndexingJobManager.merge_and_uniq_targets(nil,[])).to eq([])
      expect(DiscoveryDispatcher::IndexingJobManager.merge_and_uniq_targets(nil,nil)).to eq([])
      expect(DiscoveryDispatcher::IndexingJobManager.merge_and_uniq_targets([],nil)).to eq([])
    end
    
    it "returns true list with false targets is empty" do
      Rails.configuration.targets_url_hash={"t_target1"=>{"url"=>"url1"},"t_target2"=>{"url"=>"url2"}}
      true_targets = ["t_target1","t_target2"]
      false_targets = []
      expect(DiscoveryDispatcher::IndexingJobManager.merge_and_uniq_targets(true_targets,false_targets)).to eq(["t_target1","t_target2"]) 
    end
    it "returns false list with true targets is empty" do
      Rails.configuration.targets_url_hash={"t_target1"=>{"url"=>"url1"},"t_target2"=>{"url"=>"url2"}}
      false_targets = ["t_target1","t_target2"]
      true_targets = []
      expect(DiscoveryDispatcher::IndexingJobManager.merge_and_uniq_targets(true_targets,false_targets)).to eq(["t_target1","t_target2"]) 
    end
    it "removes the duplicate targets with the same url" do
      Rails.configuration.targets_url_hash={"t_target1"=>{"url"=>"url1"},"t_target2"=>{"url"=>"url1"},"t_target3"=>{"url"=>"url2"}}
      true_targets = ["t_target1","t_target2"]
      false_targets = ["t_target3"]
      expect(DiscoveryDispatcher::IndexingJobManager.merge_and_uniq_targets(true_targets,false_targets)).to eq(["t_target1","t_target3"]) 
    end
    
  end
end