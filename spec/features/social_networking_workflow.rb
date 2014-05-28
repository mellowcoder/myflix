require 'spec_helper'

feature "The user is able to interact with the social netwoking features of the app" do
  given(:steve) {Fabricate(:user, email: "smartin@example.com", password: "king-tut", full_name: "Steve Martin")}
  given(:william) {Fabricate(:user, email: "wshatner@example.com", password: "make-it-so", full_name: "William Shatner")}

  scenario "The user is able to follow and unfullow other users" do
    comedy = Fabricate(:category, name: 'Comedy')
    monk1 = Fabricate(:video, title: "Monk 1", small_cover_url: 'covers/monk.jpg', large_cover_url: 'covers/monk_large.jpg', category: comedy)
    monk2 = Fabricate(:video, title: "Monk 2", small_cover_url: 'covers/monk.jpg', large_cover_url: 'covers/monk_large.jpg', category: comedy)
    futurama1 = Fabricate(:video, title: "Futurama 1", small_cover_url: 'covers/futurama.jpg', large_cover_url: 'covers/futurama_large.jpg', category: comedy)
    futurama2 = Fabricate(:video, title: "Futurama 2", small_cover_url: 'covers/futurama.jpg', large_cover_url: 'covers/futurama_large.jpg', category: comedy)
    Fabricate(:review, user: william, video: futurama1)
    
    feature_sign_in(steve)
    
    # After sign in go to the videos page
    click_link "Videos"
    expect(current_path).to eq(videos_path)
    
    # Click on the Futurama 1 Video
    click_link "video_#{futurama1.id}"
    expect(current_path).to eq(video_path(futurama1))
    
    # Click on the user link for William Shatner's Review
    click_link william.full_name
    expect(current_path).to eq(user_path(william))
    expect(page).to have_content("#{william.full_name}'s video collections")
    
    # Follow William
    click_link "Follow"
    expect(current_path).to eq(people_path)
    
    # Click on the People Link and you should see William as one of the people you follow
    click_link "People"
    expect(page).to have_content("#{william.full_name}")
     
    # Unfollow William and you should no longer see William in the list of People you follow
    find("a[href='/followed_relationships/#{steve.followed_relations.first.id}']").click
    expect(current_path).to eq(people_path)
    expect(page).to_not have_content("#{william.full_name}")    
    
  end
  
end