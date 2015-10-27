require 'spec_helper'

describe ReaderLogRecords do
  it 'is valid with valid attributes' do
    expect(ReaderLogRecords.new({ last_read_time: nil, record_count: 0 })).to be_valid
  end
end
