require 'spec_helper'

describe User do
  it {should validate_presence_of(:full_name)}
  it {should validate_presence_of(:email)}
  it {should have_many(:queue_items).order("position")}
  
  describe "queue" do
    it "is an instance of My Queue" do
      user = Fabricate(:user)
      expect(user.queue).to be_an_instance_of(MyQueue)
    end
  end
  
end
