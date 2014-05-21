class QueueItemsController < ApplicationController
  before_action :require_user
  
  def index
    @queue_items = current_user.queue_items
  end
  
  def create
    queue_video(Video.find(params[:video_id]))
    redirect_to my_queue_path
  end
  
  def destroy
    item = current_user.queue_items.where(id: params[:id]).first
    item.destroy && current_user.normalize_queue_item_positions if item
    redirect_to my_queue_path
  end
  
  def update_position
    update_queue_item_positions
    redirect_to my_queue_path
  rescue
    flash[:error] = "Invalid position numbers"
    redirect_to my_queue_path
  end
  
  private
  
  def queue_video(video)
    QueueItem.create(user: current_user, video: video, position: new_queue_item_position) unless video_exists_in_users_queue?(video)
  end

  def new_queue_item_position
    current_user.queue_items.count+1
  end
  
  def video_exists_in_users_queue?(video)
    current_user.queue_items.map(&:video).include?(video)
  end
  
  def update_queue_item_positions
    QueueItem.transaction do
      params[:queue_items].keys.each do |key|
        item = QueueItem.find(key)
        item.update_attributes!(position: params[:queue_items][key]["position"]) if item.user == current_user
      end
        current_user.normalize_queue_item_positions
    end
  end


end