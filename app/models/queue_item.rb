class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  
  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video
  delegate :name, to: :category, prefix: :category
  
  validates_numericality_of :position, {only_integer: true}
  
  def rating
    review.rating if review
  end
  
  def rating=(new_rating)
    if review
      review.update_column(:rating, new_rating)
    else
      if !new_rating.blank?
        review = Review.new(user: user, video: video, rating: new_rating)
        review.save(validate: false)
      end
    end
  end
  
  private
  
  def review
    @review ||= Review.where(user_id: user.id, video_id: video.id).order(created_at: :desc).first
  end
  
end
