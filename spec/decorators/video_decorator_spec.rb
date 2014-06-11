require 'spec_helper'

describe VideoDecorator do
  
  describe "#rating_label" do
    let(:video) {Fabricate.build(:video)}
        
    it "returns N/A when the video average rating is nil" do
      expect(video.decorate.rating_label).to eq('N/A')
    end
    
    it "returns 3.7/5 when the video average rating is 3/7" do
      video.stub(:average_rating).and_return(3.7)
      expect(video.decorate.rating_label).to eq('3.7/5.0')
    end
    
  end
  
end
