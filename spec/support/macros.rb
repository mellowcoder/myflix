def login_current_user(user = Fabricate(:user))
  session[:user_id] = user.id
end

def logout_current_user
  session[:user_id] = nil
end

def current_user
  User.find(session[:user_id])
end

def feature_sign_in(given_user=nil)
  user = given_user ||= Fabricate(:user)
  visit sign_in_path
  fill_in 'Email Address', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end

def stub_stripe_charge_as_successful
  charge = double('charge')
  charge.stub(:successful?).and_return(true)
  StripeWrapper::Charge.stub(:create).and_return(charge)
end

def stub_stripe_charge_as_unsuccessful
  charge = double('charge')
  charge.stub(:successful?).and_return(false)
  charge.stub(:error_message).and_return("Your card was declined.")
  StripeWrapper::Charge.stub(:create).and_return(charge)
end