class CreateReaderLogRecords < ActiveRecord::Migration
  def change
    create_table :reader_log_records do |t|
      t.datetime :last_read_time
      t.integer :record_count

      t.timestamps
    end
  end
end
