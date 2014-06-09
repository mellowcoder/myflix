class Admin::AdministrationController < AuthenticationController
  before_action :require_admin
  
  private
  
  def require_admin
    redirect_to home_path unless current_user.admin?
  end

end
