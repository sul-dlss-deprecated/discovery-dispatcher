require 'spec_helper'

describe ReaderLogRecords do
  it 'is valid with valid attributes' do
    expect(described_class.new(last_read_time: nil, record_count: 0)).to be_valid
  end
  describe '.last_read_time' do
    it 'returns the next start time' do
      ReaderLogRecords.create(last_read_time: '2010-01-01T12:00:00 -0800', record_count: 1)
      ReaderLogRecords.create(last_read_time: '2011-01-01T12:00:00 -0800', record_count: 1)
      ReaderLogRecords.create(last_read_time: '2012-01-01T12:00:00 -0800', record_count: 1)

      start_time = described_class.last_read_time
      expect(start_time).to eq('2012-01-01T11:58:00-08:00') # note this is minus 2 mins
    end

    it 'returns nil as the start time for empty table' do
      start_time = described_class.last_read_time
      expect(start_time).to be_nil
    end
  end

  describe '.set_last_fetch_info' do
    it 'inserts the last time and the count' do
      described_class.set_last_fetch_info Time.zone.parse('2015-01-01T12:00:00 -0800').to_s, 5
      last_id = ReaderLogRecords.maximum(:id)
      record = ReaderLogRecords.find last_id
      expect(record.last_read_time).to eq(Time.zone.parse('2015-01-01T12:00:00 -0800'))
      expect(record.record_count).to eq(5)
    end
  end
end
