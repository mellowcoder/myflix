require 'spec_helper'

describe User do
  it {should validate_presence_of(:full_name)}
  it {should validate_presence_of(:email)}
  it {should have_many(:queue_items).order("position")}
  it {should have_many(:reviews).order("created_at desc")}
  it {should have_many(:followed_relations)}
  it {should have_many(:follower_relations)}
  # it {should have_many(:followed_people).through(:followed_relations)}
  # it {should have_many(:followers).through(:follower_relations)}
  
  describe "queue" do
    it "is an instance of My Queue" do
      user = Fabricate(:user)
      expect(user.queue).to be_an_instance_of(MyQueue)
    end
  end
  
end
