class MyQueue
    
  attr_reader :owner
  
  def initialize(owner)
    @owner = owner
  end
  
  def items
    @items ||= owner.queue_items
  end
  
  def video_exists_in_queue?(video)
    items.map(&:video).include?(video)
  end
  
  
  def add_video(video)
    QueueItem.create(user: owner, video: video, position: new_queue_item_position) unless video_exists_in_queue?(video)
  end
  
  def remove_item(id)
    item = items.where(id: id).first
    item.destroy && normalize_queue_item_positions if item
  end
  
  def update_items(items)
    ActiveRecord::Base.transaction do
      items.each_pair do |key, item_data|
        item = QueueItem.find(key)
        item.update_attributes!(position: item_data["position"], rating: item_data["rating"]) if item.user == owner
      end
        normalize_queue_item_positions
    end
  end
  
  
  private
  
  def new_queue_item_position
    items.count+1
  end
  
  def normalize_queue_item_positions
    items.each_with_index do |item, index|
      item.update_attributes(position: index+1)
    end
  end
  
end
