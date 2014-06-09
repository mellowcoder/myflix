require 'spec_helper'

feature "A User Manages Their Queue" do
  given(:steve) {Fabricate(:user, email: "smartin@example.com", password: "king-tut", full_name: "Steve Martin")}
               
  scenario "adding videos to queue and reordering queue" do
    
    comedy = Fabricate(:category, name: 'Comedy')
    monk1 = Fabricate(:video, title: "Monk 1", category: comedy)
    monk2 = Fabricate(:video, title: "Monk 2", category: comedy)
    futurama1 = Fabricate(:video, title: "Futurama 1", category: comedy)
    futurama2 = Fabricate(:video, title: "Futurama 2", category: comedy)

    feature_sign_in(steve)
    
    # After sign in they should be redirected to the home page after sign in
    expect(current_path).to eq(home_path)

    # View a video
    click_link "video_#{monk1.id}"
    expect_current_to_be_the_path_for_video(monk1)
    
    # Add the video to your queue
    click_link("+ My Queue")
    expect(current_path).to eq(my_queue_path)
    expect(page).to have_content(monk1.title)
    
        
    # Return to the video from the link in the queue and verify that you can not add the video to the queue a second time
    click_link(monk1.title)
    expect_current_to_be_the_path_for_video(monk1)
    expect(current_path).to eq(video_path(monk1))
    expect_to_not_see_add_to_queue_link
    
    # Add additional videos and verify that they appear in the queue
    add_video(monk2)
    add_video(futurama1)
    expect_video_to_be_in_queue(monk1)
    expect_video_to_be_in_queue(monk2)
    expect_video_to_be_in_queue(futurama1)
    
    # Reorder the queue and verify that it updates
    set_video_postion(monk1, 5)
    set_video_postion(monk2, 7)
    set_video_postion(futurama1, 6)
    click_button 'Update Instant Queue'
    expect_video_postion(monk1, 1)
    expect_video_postion(monk2, 3)
    expect_video_postion(futurama1, 2)
    
  end
  
end

def add_video(video)
  click_link("Videos")
  click_link "video_#{video.id}"
  click_link("+ My Queue")
end

def set_video_postion(video, position)
  find("input[data-video-id='#{video.id}']").set(position)
end

def expect_to_not_see_add_to_queue_link
  expect(page).to_not have_content("+ My Queue")
  expect(page).to have_content("In Your Queue")
end

def expect_current_to_be_the_path_for_video(video)
  expect(current_path).to eq(video_path(video))
end

def expect_video_to_be_in_queue(video)
  expect(page).to have_content(video.title)
end

def expect_video_postion(video, position)
  expect(find("input[data-video-id='#{video.id}']").value).to eq(position.to_s)
end



