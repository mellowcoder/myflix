require 'spec_helper'

describe User do
  it {should validate_presence_of(:full_name)}
  it {should validate_presence_of(:email)}
  it {should have_many(:queue_items).order("position")}
  it {should have_many(:reviews).order("created_at desc")}
  it {should have_many(:followed_relations)}
  it {should have_many(:follower_relations)}
  it {should have_many(:invites)}
  it {should belong_to(:registration_invite)}
  
  describe "queue" do
    it "is an instance of My Queue" do
      user = Fabricate(:user)
      expect(user.queue).to be_an_instance_of(MyQueue)
    end
  end
  
  describe "follows?" do
    it "returns true if the user follows the other user" do
      user = Fabricate(:user)
      other_user = Fabricate(:user)
      relation = Fabricate(:relationship, follower: user, followed: other_user)
      expect(user.follows?(other_user)).to be_true
    end
    it "returns false if the user does not follow the other user" do
      user = Fabricate(:user)
      other_user = Fabricate(:user)
      expect(user.follows?(other_user)).to be_false
    end
  end
  
  describe "can_follow?" do
    it "returns true if the user can follow the other user" do
      user = Fabricate(:user)
      other_user = Fabricate(:user)
      expect(user.can_follow?(other_user)).to be_true
    end
    it "returns false if the user is the other user" do
      user = Fabricate(:user)
      expect(user.can_follow?(user)).to be_false
    end
    it "returns false if the user is already following the other user" do
      user = Fabricate(:user)
      other_user = Fabricate(:user)
      relation = Fabricate(:relationship, follower: user, followed: other_user)
      expect(user.can_follow?(other_user)).to be_false
    end
        
  end 
  
  describe "save with an associated invite" do
    it "has the new user follow the friend" do
      friend = Fabricate(:user)
      invite = Fabricate(:invite, user: friend)
      User.new(Fabricate.attributes_for(:user, invite_id: invite.id)).save
      expect(User.last.follows?(friend)).to be_true
    end
    it "has the friend follow the new user" do
      friend = Fabricate(:user)
      invite = Fabricate(:invite, user: friend)
      User.new(Fabricate.attributes_for(:user, invite_id: invite.id)).save
      expect(friend.follows?(User.last)).to be_true
    end
  end
  
  describe "deactivate!" do
    it "sets a users active field to false" do
      user = Fabricate(:user)
      user.deactivate!
      expect(user.reload.active?).to be_false
    end
    
  end
  
end
