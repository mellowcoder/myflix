require 'spec_helper'

describe MyQueue do
  let(:user) {Fabricate(:user)}
  let(:video) {Fabricate(:video)}

  describe "items" do
    it "returns the queue items that belong to the owner" do
      Fabricate(:queue_item, user: user, video: video)
      expect(user.queue.items).to eq(user.queue_items)
    end
  end
  
  describe "count" do
    it "returns a count of the items in the queue" do
      Fabricate(:queue_item, user: user, video: video)
      expect(user.queue.count).to eq(1)
    end
  end
  
  describe "video_exists_in_queue?" do
    it "returns true of the video is already in the queue" do
      Fabricate(:queue_item, user: user, video: video)
      expect(user.queue.video_exists_in_queue?(video)).to be_true
    end
  
    it "returns false if the video is not in the queue" do
      Fabricate(:queue_item, user: user, video: video)
      other_video = Fabricate(:video)
      expect(user.queue.video_exists_in_queue?(other_video)).to be_false
    end
  end

end
