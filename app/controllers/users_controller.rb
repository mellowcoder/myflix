class UsersController < ApplicationController
  before_action :require_user, except: [:new, :create]
  
  def show
    @user = User.find(params[:id])
  end

  def new
    invite_token = params[:token]
    @user = User.new(params_from_invite(invite_token))
  end
  
  def create
    registration = Registration.new(user_params, params[:stripeToken])
    if registration.save
      flash[:success] = "Thank you for registering with my flix"
      redirect_to sign_in_path
    else
      @user = registration.user
      flash[:error] = @user.errors[:credit_card].empty? ? "Error Processing your registration" : @user.errors[:credit_card].first
      render :new
    end
  end
  
  
  private
  
  def user_params
    params.require(:user).permit(:full_name, :email, :password, :invite_id)
  end
  
  def get_invite(token)
    Invite.find_by_token(token) if token
  end
  
  def params_from_invite(token)
    invite = get_invite(token)
    invite ? {registration_invite: get_invite(token), email: invite.email} : {} 
  end
end