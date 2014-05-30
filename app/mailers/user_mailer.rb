class UserMailer < ActionMailer::Base
  default from: "welcome@myflix.com"
  
  def welcome_email(user)
      @user = user
      @url  = 'http://mark-flix.herokuapp.com/'
      mail(to: @user.email, subject: 'Welcome to Mark Flix')
    end  
  
end
