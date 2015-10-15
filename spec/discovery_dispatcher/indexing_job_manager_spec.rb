describe DiscoveryDispatcher::IndexingJobManager do
  before :each do
    Delayed::Job.delete_all
  end
  after :each do
    Delayed::Job.delete_all
  end
  describe '.enqueue_records' do
    it 'calls enqueue_delete_record_from_all_targets for record[:type] = delete && record[:target] nil' do
      records = { type: 'delete', druid: 'ab123cd4567' }, { type: 'delete', druid: 'cd123ef4567' }
      expect(DiscoveryDispatcher::IndexingJobManager).to receive(:enqueue_delete_record_from_all_targets).with(records.first)
      expect(DiscoveryDispatcher::IndexingJobManager).to receive(:enqueue_delete_record_from_all_targets).with(records.last)
      expect(DiscoveryDispatcher::IndexingJobManager).to_not receive(:enqueue_process_record)
      DiscoveryDispatcher::IndexingJobManager.enqueue_records records
    end
    it 'calls enqueue_process_record for record[:type] = delete && record[:target] not nil' do
      records = { type: 'index', druid: 'cd123ef4567', target: 'Searchworks' }, { type: 'delete', druid: 'cd123ef4567', target: 'Revs' }
      expect(DiscoveryDispatcher::IndexingJobManager).to receive(:enqueue_process_record).with(records.first)
      expect(DiscoveryDispatcher::IndexingJobManager).to receive(:enqueue_process_record).with(records.last)
      expect(DiscoveryDispatcher::IndexingJobManager).to_not receive(:enqueue_delete_record_from_all_targets)
      DiscoveryDispatcher::IndexingJobManager.enqueue_records records
    end
    it 'calls enqueue_process_record for record[:type] not delete && record[:target] not nil' do
      records = { type: 'index', druid: 'gh123ij4567', target: 'Revs' }, { type: 'delete', druid: 'cd123ef4567', target: 'Searchworks' }
      expect(DiscoveryDispatcher::IndexingJobManager).to receive(:enqueue_process_record).with(records.first)
      expect(DiscoveryDispatcher::IndexingJobManager).to receive(:enqueue_process_record).with(records.last)
      expect(DiscoveryDispatcher::IndexingJobManager).to_not receive(:enqueue_delete_record_from_all_targets)
      DiscoveryDispatcher::IndexingJobManager.enqueue_records records
    end
    it 'does not process index records with empty targets' do
      records = { type: 'index', druid: 'ab123cd4567' }, { type: 'index', druid: 'cd123ef4567' }
      DiscoveryDispatcher::IndexingJobManager.enqueue_records records
      expect(Delayed::Job.all.size).to eq(0)
    end
  end

  describe '.enqueue_delete_record_from_all_targets' do
    it 'enqueues the record with all available targets' do
      record = {}
      record[:type] = 'delete'
      record[:druid] = 'ab123cd4567'
      Rails.configuration.targets_url_hash = { 't_target1' => { 'url' => 'url1' }, 't_target2' => { 'url' => 'url2' } }
      DiscoveryDispatcher::IndexingJobManager.enqueue_delete_record_from_all_targets record
      last_id = Delayed::Job.last.id
      expect(Delayed::Job.find(last_id - 1).handler).to eq("--- !ruby/struct:DiscoveryDispatcher::IndexingJob\ntype: delete\ndruid_id: ab123cd4567\ntarget: t_target1\n")
      expect(Delayed::Job.find(last_id).handler).to eq("--- !ruby/struct:DiscoveryDispatcher::IndexingJob\ntype: delete\ndruid_id: ab123cd4567\ntarget: t_target2\n")
      expect(Delayed::Job.all.size).to eq(2)
    end
  end

  describe '.enqueue_process_record' do
    it 'enqueues a record for index for specified target' do
      record = { type: 'index', druid: 'cd123ef4567', target: 't_target1' }
      Rails.configuration.targets_url_hash = { 't_target1' => { 'url' => 'url1' }, 't_target2' => { 'url' => 'url2' } }
      DiscoveryDispatcher::IndexingJobManager.enqueue_process_record record
      expect(Delayed::Job.last.handler).to eq("--- !ruby/struct:DiscoveryDispatcher::IndexingJob\ntype: index\ndruid_id: cd123ef4567\ntarget: t_target1\n")
      expect(Delayed::Job.all.size).to eq(1)
    end
    it 'enqueues a record for delete for specified target' do
      record = { type: 'delete', druid: 'cd123ef4567', target: 't_target1' }
      Rails.configuration.targets_url_hash = { 't_target1' => { 'url' => 'url1' }, 't_target2' => { 'url' => 'url2' } }
      DiscoveryDispatcher::IndexingJobManager.enqueue_process_record record
      expect(Delayed::Job.last.handler).to eq("--- !ruby/struct:DiscoveryDispatcher::IndexingJob\ntype: delete\ndruid_id: cd123ef4567\ntarget: t_target1\n")
      expect(Delayed::Job.all.size).to eq(1)
    end
  end
end
