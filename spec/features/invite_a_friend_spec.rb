require 'spec_helper'

feature "Invite a friend" do
  background {clear_emails}
  given(:steve) {Fabricate(:user, email: "smartin@example.com", password: "king-tut", full_name: "Steve Martin")}
  
  scenario "The user invites a friend who registers for our app", {vcr: true, js: true} do

    # Steve invites his friend Louis to register
    feature_sign_in(steve)
    steve_navigates_to_friend_invite_page
    steve_invites_louis    
    visit sign_out_path
    
    # Louis registers
    louis_reads_the_invite_email
    louis_registers
    louis_signs_in
    verifies_following(steve.full_name)
    visit sign_out_path
    
    # Steve verifies that he is following Louis
    feature_sign_in(steve)
    verifies_following('Louis C.K.')
    
  end


  def steve_navigates_to_friend_invite_page
    expect(current_path).to eq(home_path)
    visit new_invite_path
    expect(current_path).to eq(new_invite_path)
  end

  def steve_invites_louis
    fill_in('invite[name]', with: 'Louis C.K.')
    fill_in('invite[email]', with: 'lck@stars.com')
    fill_in('invite[message]', with: 'This site is great!')
    click_button 'Send Invitation'
    expect(current_path).to eq(invite_confirmed_path)
    expect(page).to have_content('sent your friend an invitation')
  end

  def louis_reads_the_invite_email
    open_email('lck@stars.com')
    current_email.click_link 'Register'
    expect(page).to have_content('Register')
    expect(find_field("user[email]").value).to eq('lck@stars.com')
  end

  def louis_registers
    # Email should be pre-filled
    fill_in('Full Name', with: 'Louis C.K.')
    fill_in('Password', with: 'secret')
    fill_in('Credit Card Number', with: '4242424242424242')
    fill_in('Security Code', with: '1234')
    select "7 - July", from: "date_month"
    select (Time.now.year+1).to_s, from: "date_year"
    click_button "Sign Up"
    expect(current_path).to eq(sign_in_path)
  end

  def louis_signs_in
    fill_in 'Email Address', with: 'lck@stars.com'
    fill_in 'Password', with: 'secret'
    click_button 'Sign in'
    expect(current_path).to eq(home_path)
  end

  def verifies_following(full_name)
    click_link 'People'
    expect(page).to have_content(full_name)
  end

end
