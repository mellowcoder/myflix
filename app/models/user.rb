class User < ActiveRecord::Base
  has_secure_password
  has_secure_password validations: false
  has_many :queue_items, -> {order "position"}
  has_many :reviews, -> {order "created_at desc"}
  has_many :followed_relations, class_name: "Relationship", foreign_key: :follower_id
  has_many :follower_relations, class_name: "Relationship", foreign_key: :followed_id

  validates_presence_of :full_name, :email, :password
  validates_uniqueness_of :email
  
  def queue
    @queue ||= MyQueue.new(self)
  end
  
  def follows?(other_user)
    followed_relations.map(&:followed_id).member?(other_user.id)
  end
  
  def can_follow?(other_user)
    other_user != self && !follows?(other_user)
  end
  
  def set_password_reset_token
    update_attribute(:password_reset_token, SecureRandom.urlsafe_base64(36))
  end
  
  def reset_password(new_password)
    self.password = new_password
    self.password_reset_token = nil
    self.save
  end
end
