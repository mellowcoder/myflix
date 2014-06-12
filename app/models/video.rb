class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> {order "created_at desc"}
  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader
  
  validates_presence_of :title, :description
  validates_presence_of :category
  
  def self.search_by_title(title)
    return [] if title.blank?
    Video.where('title ilike ?', "%#{title}%").order(created_at: :desc)
  end
  
  def average_rating
    reviews.average(:rating).round(1) if reviews.count > 0
  end
  
end
