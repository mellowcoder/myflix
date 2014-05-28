module VideosHelper
  
  def hide_add_to_queue_link    
    current_user.queue.video_exists_in_queue?(@video)
  end
  
end
