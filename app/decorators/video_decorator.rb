class VideoDecorator < Draper::Decorator
  delegate_all

  def rating_label
    average_rating.blank? ? 'N/A' :  "#{average_rating}/5.0"
  end
end
