class UserMailer < ActionMailer::Base
  default from: "support@myflix.com"
  
  def welcome_email(user)
      @user = user
      @url  = 'http://mark-flix.herokuapp.com/'
      mail(to: @user.email, subject: 'Welcome to Mark Flix')
    end  
  
  def reset_password_email(user)
    @user = user
    mail(to: @user.email, subject: 'Password Reset')
  end
end
