require 'spec_helper'

feature "Reset a forgotten password" do
  background {clear_emails}
  given(:steve) {Fabricate(:user, email: "smartin@example.com", password: "king-tut", full_name: "Steve Martin")}
  
  scenario "The user is able to reset their password and log into the site" do
  
    # visit the Sign In page
    visit sign_in_path
    click_link 'Forgot Password?'
    expect(current_path).to eq(forgot_password_path)
  
    # enter email and submit
    fill_in('email', :with => steve.email)
    click_button 'Send Email'
  
    # go to the email and click on the link to reset your password
    open_email(steve.email)
    current_email.click_link 'Reset Password'
    expect(page).to have_content("Reset Your Password")
    
    # enter a new password
    fill_in('password', :with => 'lets-get-small')
    click_button 'Reset Password'
    expect(current_path).to eq(sign_in_path)
    expect(page).to have_content('Your password was successfully reset')
    
    # sign in using the new password
    fill_in 'Email Address', with: steve.email
    fill_in 'Password', with: 'lets-get-small'
    click_button 'Sign in'
    expect(current_path).to eq(home_path)
    expect(page).to have_content(steve.full_name)
    
  end

end

