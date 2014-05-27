feature "Sign in" do
  given(:steve) {Fabricate(:user, email: "smartin@example.com", password: "king-tut", full_name: "Steve Martin")}

  scenario "with valid credentials" do
    visit sign_in_path
    fill_in 'Email Address', with: steve.email
    fill_in 'Password', with: steve.password
    click_button 'Sign in'
    expect(page).to have_content steve.full_name
  end
  
  scenario "with invalid credentials" do
    visit sign_in_path
    fill_in 'Email Address', with: steve.email
    fill_in 'Password', with: steve.password+'xyz'
    click_button 'Sign in'
    expect(page).to have_content 'Invalid email or password'
  end
  
end
