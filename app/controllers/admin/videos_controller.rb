class Admin::VideosController < Admin::AdministrationController
  
  def new
    @video = Video.new
  end
    
  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "Video was successfully saved"
      redirect_to new_admin_video_path
    else
      flash[:error] = "The was an error with saving the video"
      render :new
    end
  end
  
  def video_params
    params.require(:video).permit(:title, :description, :category_id, :large_cover, :small_cover)
  end
  
end
