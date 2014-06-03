class UsersController < ApplicationController
  before_action :require_user, except: [:new, :create]
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.welcome_email(@user).deliver
      redirect_to sign_in_path
    else
      render :new
    end
  end
  
  
  private
  
  def user_params
    params.require(:user).permit(:full_name, :email, :password)
  end
  
end