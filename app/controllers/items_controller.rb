class ItemsController < ApplicationController
  respond_to :json

  def new
    type = params[:type]
    druid = params[:druid]
    targets = params[:targets]
    record = { type: type, druid: druid, targets: targets }
    DiscoveryDispatcher.IndexingJobManager.enqueue_process_record record
    @status = "#{druid} is enqueued successfully into the process queue"
  rescue
  end

  def delete
  end
end
