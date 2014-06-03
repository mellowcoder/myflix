require 'spec_helper'

feature "Invite a friend" do
  background {clear_emails}
  given(:steve) {Fabricate(:user, email: "smartin@example.com", password: "king-tut", full_name: "Steve Martin")}
  
  scenario "The user invites a friend who registers for our app" do

    # Steve invites his friend Louis to register
    feature_sign_in(steve)
    steve_navigates_to_friend_invite_page
    steve_invites_louis    
    click_link 'Sign Out'
    
    # Louis registers
    louis_reads_the_invite_email
    louis_registers
    louis_signs_in
    verifies_following(steve.full_name)
    click_link 'Sign Out'
    
    # Steve verifies that he is following Louis
    feature_sign_in(steve)
    verifies_following('Louis C.K.')
    
  end


  def steve_navigates_to_friend_invite_page
    click_link 'Invite a friend'
    expect(current_path).to eq(new_invite_path)
  end

  def steve_invites_louis
    fill_in('invite[name]', :with => 'Louis C.K.')
    fill_in('invite[email]', :with => 'lck@stars.com')
    fill_in('invite[message]', :with => 'This site is great!')
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
    fill_in('user[full_name]', :with => 'Louis C.K.')
    fill_in('user[password]', :with => 'secret')
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
