require 'spec_helper'

feature "Video upload and view" do
  background {Fabricate(:category, name: 'Comedy')}
  given(:john_the_admin) {Fabricate(:user, email: "john@example.com", password: "admins-rule", full_name: "John J. Admin", admin: true)}
  given(:steve_the_user) {Fabricate(:user, email: "smartin@example.com", password: "king-tut", full_name: "Steve Martin")}
  # given(:comedy_catgory) {Fabricate(:category, name: 'Comedy')}
  
  scenario "An admin creates a new video and a user is then able to play the video" do
    #John the admin logs into MyFlix and creates a new video
    feature_sign_in(john_the_admin)
    visit(new_admin_video_path)
    expect(page).to have_content("Add a New Video")
    fill_in('Title', with: 'Demon')
    select('Comedy', from: 'Category')
    fill_in('Description', with: 'A demon\'s life')
    attach_file "Large cover", "spec/support/uploads/demon-large.png" 
    attach_file "Small cover", "spec/support/uploads/demon.png"
    fill_in "Video URL", with: "http://example.com/demon.mov"
    click_button 'Add Video' 
    click_link 'Sign Out'
    
    
    #Steve the user logs in and goes to the new video
    feature_sign_in(steve_the_user)
    visit(video_path(Video.first))
    expect(page).to have_selector("img[src='http://www.example.com/uploads/video/large_cover/#{Video.first.id}/demon-large.png']")
    expect(page).to have_selector("a[href='http://example.com/demon.mov']")
    
  end
  
end

