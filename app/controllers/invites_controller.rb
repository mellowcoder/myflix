class InvitesController < ApplicationController
  before_action :require_user
  
  def new
    @invite = Invite.new(message: 'Please join this really cool site!')
  end
  
  def create
    @invite = current_user.invites.new(invite_params)
    if @invite.save
      InviteMailer.delay.friend_invite(@invite.id)
      redirect_to invite_confirmed_path
    else
      render :new
    end
  end
  
  private
  
  def invite_params
    params.require(:invite).permit(:name, :email, :message)
  end
  
  
end
