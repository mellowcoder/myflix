class QueueItemsController < ApplicationController
  before_action :require_user
  
  def index
    @queue_items = current_user.queue.items
  end
  
  def create
    current_user.queue.add_video(Video.find(params[:video_id]))
    redirect_to my_queue_path
  end
  
  def destroy
    current_user.queue.remove_item(params[:id])
    redirect_to my_queue_path
  end
  
  def update_queue
    current_user.queue.update_items(params[:queue_items])
    redirect_to my_queue_path
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "Invalid position numbers"
    redirect_to my_queue_path
  end

end

