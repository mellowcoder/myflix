class Admin::VideosController < Admin::AdministrationController
  
  def new
    @video = Video.new
  end
    
end
