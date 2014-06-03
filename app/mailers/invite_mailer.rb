class InviteMailer < ActionMailer::Base
  default from: "support@myflix.com"

  def friend_invite(invite)
    @invite = invite
    @friend = invite.user
    mail(to: @invite.email, subject: 'An invitation to join MyFlix')
  end
  
end
