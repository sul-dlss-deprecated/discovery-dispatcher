class ItemsController < ApplicationController
  respond_to :json
  def new
    type = params[:type]
    druid = params[:druid]
    targets = params[:targets]
    raise 'missing required params' unless type && druid && targets
    record = { type: type, druid: druid, targets: targets }
    DiscoveryDispatcher::IndexingJobManager.enqueue_process_record record
    @status = "#{druid} is enqueued successfully into the process queue"
    render json: @status.to_json
  rescue => e
    Rails.logger.error { "Items controller failed to add a new item to the queue\n#{e.message}" }
    render json: e.message, :status=>500
  end
end
