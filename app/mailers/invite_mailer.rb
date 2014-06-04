class InviteMailer < ActionMailer::Base
  default from: "support@myflix.com"

  def friend_invite(invite_id)
    @invite = Invite.where(id: invite_id).first
    if @invite
      @friend = @invite.user
      mail(to: @invite.email, subject: 'An invitation to join MyFlix')
    end
  end
  
end
