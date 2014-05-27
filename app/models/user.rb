class User < ActiveRecord::Base
  has_secure_password
  has_secure_password validations: false
  has_many :queue_items, -> {order "position"}
  
  validates_presence_of :full_name, :email
  validates_uniqueness_of :email
  
  def queue
    @queue ||= MyQueue.new(self)
  end
  
  def normalize_queue_item_positions
    queue_items.each_with_index do |item, index|
      item.update_attributes(position: index+1)
    end
  end
  
end
