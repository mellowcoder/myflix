class MyQueue
    
  def initialize(owner)
    @owner = owner
  end
  
  def items
    @items ||= @owner.queue_items
  end
  
  def video_exists_in_queue?(video)
    items.map(&:video).include?(video)
  end
  
  def normalize_queue_item_positions
    items.each_with_index do |item, index|
      item.update_attributes(position: index+1)
    end
  end
  
end
