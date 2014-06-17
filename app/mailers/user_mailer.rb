class UserMailer < ActionMailer::Base
  default from: "support@myflix.com"
  
  def welcome_email(user_id)
      @user = User.where(id: user_id).first
      if @user
        @url  = 'http://mark-flix.herokuapp.com/'
        mail(to: @user.email, subject: 'Welcome to Mark Flix')
      end
    end  
  
  def reset_password_email(user_id)
    @user = User.where(id: user_id).first
    if @user
      mail(to: @user.email, subject: 'Password Reset')
    end
  end
  
  def account_deactivated_email(user_id)
    @user = User.where(id: user_id).first
    if @user
      mail(to: @user.email, subject: 'Account Deactivate')
    end
  end
  
end
