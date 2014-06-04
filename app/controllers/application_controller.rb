class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
  
  def require_user
    redirect_to sign_in_path unless current_user
  end

  def require_admin
    redirect_to home_path unless current_user.admin?
  end
  
  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end
  
  helper_method :current_user
  
end
