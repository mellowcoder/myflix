require 'spec_helper'

describe Registration do
  
  describe "#save" do
    context "with valid inputs" do
      before {stub_stripe_charge_as_successful}
      let(:reg) {Registration.new(Fabricate.attributes_for(:user), 'stripe_token')}
      it "creates a new user" do
        reg.save
        expect(User.count).to eq(1)
      end
      
      it "charges the users card" do
        reg.save
        expect(reg.card_charged?).to be_true
      end
      
      it "returns true" do
        expect(reg.save).to be_true
      end
    end
    
    context "with invalid user inputs" do
      before {stub_stripe_charge_as_successful}
      let(:reg) {Registration.new(Fabricate.attributes_for(:user, email: ''), 'stripe_token')}
      it "does not create a user" do
        reg.save
        expect(User.count).to eq(0)
      end
      it "it does not charge the users card" do
        reg.save
        expect(reg.card_charged?).to be_false
      end
      it "returns false" do
        expect(reg.save).to be_false
      end
    end
    
    context "with invalid credit card inputs" do
      before {stub_stripe_charge_as_unsuccessful}
      let(:reg) {Registration.new(Fabricate.attributes_for(:user), 'stripe_token')}
      it "does not create a user" do
        reg.save
        expect(User.count).to eq(0)
      end
      it "it does not charge the users card" do
        reg.save
        expect(reg.card_charged?).to be_false
      end
      
      it "returns false" do
        expect(reg.save).to be_false
      end
      it "sets the credit_card error message on the user" do
        reg.save
        expect(reg.user.errors[:credit_card]).to_not be_blank
      end
      
    end
    
    
  end
  


end