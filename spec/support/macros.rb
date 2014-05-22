def login_current_user
  user = Fabricate(:user)
  session[:user_id] = user.id
end

def logout_current_user
  session[:user_id] = nil
end

def current_user
  User.find(session[:user_id])
end