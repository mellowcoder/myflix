class ReviewsController < AuthenticationController
  
  def create
    @video = Video.find(params[:video_id])
    review = @video.reviews.build(review_params.merge!(user: current_user))
    if review.save
      redirect_to @video
    else
      @reviews = @video.reviews.reload
      @video = @video.decorate
      render 'videos/show'
    end
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def review_params
    params.require(:review).permit(:rating, :content)
  end
  
end
