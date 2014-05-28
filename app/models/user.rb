class User < ActiveRecord::Base
  has_secure_password
  has_secure_password validations: false
  has_many :queue_items, -> {order "position"}
  has_many :reviews, -> {order "created_at desc"}
  has_many :followed_relations, class_name: "Relationship", foreign_key: :follower_id
  has_many :follower_relations, class_name: "Relationship", foreign_key: :followed_id

  # has_many :followed_people, class_name: "User", through: :followed_relations, source: :followed
  # has_many :followers, class_name: "User", through: :follower_relations, source: :follower

  validates_presence_of :full_name, :email
  validates_uniqueness_of :email
  
  def queue
    @queue ||= MyQueue.new(self)
  end

end
