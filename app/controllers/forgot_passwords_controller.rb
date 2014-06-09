class ForgotPasswordsController < ApplicationController

  def create
    user = User.where(email: params[:email]).first
    if user
      user.set_password_reset_token
      UserMailer.delay.reset_password_email(user.id)
      redirect_to forgot_password_confirmation_path
    else
      flash[:error] = "Invalid email address"
      redirect_to forgot_password_path
    end
  end
  
  def edit
    @user = User.where(password_reset_token: params[:id]).first
    redirect_to invalid_token_path unless @user
  end
  
  def update
    @user = User.where(password_reset_token: params[:id]).first
    if @user
      if @user.reset_password(params[:password]) && @user.errors.blank?
        flash[:success] = "Your password was successfully reset"
        redirect_to sign_in_path
      else
        @user.reload
        flash.now[:error] = "Password entered was invalid"
        render :edit
      end
    else
      redirect_to invalid_token_path
    end
  end
  
  
end

