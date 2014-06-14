require 'spec_helper'

describe Registration do
  
  describe "#save" do
    before do
      ActionMailer::Base.deliveries.clear
    end
    
    context "with valid inputs" do      
      before {stub_stripe_customer_with_plan_as_successful}
      let(:reg) {Registration.new(Fabricate.attributes_for(:user), 'stripe_token')}
      it "creates a new user" do
        reg.save
        expect(User.count).to eq(1)
      end
      it "charges the users card" do
        reg.save
        expect(reg.card_charged?).to be_true
      end
      it "sends a welcome email when a new user is created" do
        reg.save
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end
      it "sends the email to the new users email address" do
        reg.save
        invite_email = ActionMailer::Base.deliveries.last
        expect(invite_email.to[0]).to eq(User.last.email)
      end
      it "sends a welcome email with the users full_name in the body" do
        reg.save
        invite_email = ActionMailer::Base.deliveries.last
        expect(invite_email.body).to include(User.last.full_name)
      end
      it "returns true" do
        expect(reg.save).to be_true
      end
    end

    context "with invalid user inputs" do
      before {stub_stripe_customer_with_plan_as_successful}
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
      it "does not sends a welcome email" do
        reg.save
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      
    end
    
    context "with invalid credit card inputs" do
      before {stub_stripe_customer_with_plan_as_unsuccessful}
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
      it "does not sends a welcome email" do
        reg.save
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
    
  end
end