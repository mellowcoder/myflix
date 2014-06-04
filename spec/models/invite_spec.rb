require 'spec_helper'

describe Invite do
  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:email)}
  it {should validate_presence_of(:user)}
  
  it {should belong_to(:user)}
  
  it_behaves_like "tokened" do
    let(:object) {Fabricate(:invite)}
  end
  
end
