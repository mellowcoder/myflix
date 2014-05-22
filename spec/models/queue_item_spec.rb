require 'spec_helper'

describe QueueItem do
  it {should belong_to(:user)}
  it {should belong_to(:video)}
  it {should validate_numericality_of(:position).only_integer}
  describe "#video_title" do
    it "returns the title of the associated video" do
      video = Fabricate(:video, title: "Cheers")
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq("Cheers")
    end
  end
 
  describe "#category_name" do
    it "returns the name of the associated video's associtated category" do
      category = Fabricate(:category, name: "Comedy")
      video = Fabricate(:video, title: "Cheers", category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq("Comedy")
    end
  end

  describe "#category" do
    it "returns the category instance for the associated video" do
      category = Fabricate(:category, name: "Comedy")
      video = Fabricate(:video, title: "Cheers", category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category)
    end
  end
  
  describe "#rating" do
    it "returns the rating from the review if the user has revied the associated video" do
      queue_item = Fabricate(:queue_item)
      Fabricate(:review, video: queue_item.video, user: queue_item.user, rating: 4)
      expect(queue_item.rating).to eq(4)
    end
    
    it "returns nil if the user has not reviewed the assocaiated video" do
      queue_item = Fabricate(:queue_item)
      expect(queue_item.rating).to be_nil
    end
  end
  
  describe "#rating=" do
    it "updates the rating of review if the review exists" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, user: user, video: video, rating: 2)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = 4
      expect(Review.first.rating).to eq(4)
    end
    
    it "it removes the review if the rating is cleared for an existing review" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, user: user, video: video, rating: 2)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = nil
      expect(Review.first.rating).to be_nil
    end 
    
    it "creates a review and sets the rating if it does not already exist" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = 4
      expect(Review.first.rating).to eq(4)
    end
    
  end
  
  
end
