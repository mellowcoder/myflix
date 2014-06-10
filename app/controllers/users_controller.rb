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
    @user = User.new(user_params)
    if @user.save
      if !Rails.env.test?
        charge = StripeWrapper::Charge.create(amount: 999, card: params[:stripeToken], description: "MyFlix Sign up charge for #{@user.email}")
        if charge.successful?
          Stripe.api_key = Rails.application.secrets.stripe_secret_key
          charge = Stripe::Charge.create( amount: 999, currency: "usd", card: params[:stripeToken], description: "MyFlix Sign up charge for #{@user.email}")
        else
          flash[:error] = "Your account was created but there was a credit card error: #{charge.error_message}"
        end
      end
      UserMailer.delay.welcome_email(@user.id)
      redirect_to sign_in_path
    else
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