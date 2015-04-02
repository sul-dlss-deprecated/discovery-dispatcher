class ItemsController < ApplicationController
      respond_to :json

  def new
    begin
      druid = params[:druid]
      targets = params[:targets]
      record = {:type=>"index", :druid=>druid, :targets=> targets}
      DiscoveryDispatcher.IndexingJobManager.enqueu_index_record record
      @status = "#{druid} is enqueued successfully into the index enqueue"
    rescue
      
    end
  end

  def delete
  end
end
