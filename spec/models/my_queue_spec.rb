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

  describe "video_exists_in_queue?" do
    it "returns true of the video is already in the queue" do
      Fabricate(:queue_item, user: user, video: video)
      expect(user.queue.video_exists_in_queue?(video)).to eq(true)
    end
  
    it "returns false if the video is not in the queue" do
      Fabricate(:queue_item, user: user, video: video)
      other_video = Fabricate(:video)
      expect(user.queue.video_exists_in_queue?(other_video)).to eq(false)
    end
  end
  
  describe "normalize_queue_item_positions" do
    it "renumbers the queue items in sequental sequence" do
      Fabricate(:queue_item, user: user, video: video, position: 5)
      Fabricate(:queue_item, user: user, video: video, position: 6)
      user.queue.normalize_queue_item_positions
      expect(user.queue.items.map(&:position)).to eq([1,2])
    end
  end
  

end
