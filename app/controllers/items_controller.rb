class ItemsController < ApplicationController
  respond_to :json
  def new
    DiscoveryDispatcher::IndexingJobManager.enqueue_process_record record_params
    @status = "#{record_params[:druid]} is enqueued successfully into the process queue"
    render json: @status.to_json
  rescue => e
    Rails.logger.error { "Items controller failed to add a new item to the queue\n#{e.message}" }
    render json: e.message, :status=>500
  end

  private
  def record_params
    params.require(:type)
    params.require(:druid)
    params.require(:targets)
    params.slice(:type, :druid, :targets)
  end

end
