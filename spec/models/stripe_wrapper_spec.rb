require 'spec_helper'

describe StripeWrapper::Charge, :vcr do
  before {StripeWrapper.set_api_key}
  let(:token) {Stripe::Token.create(:card => {:number => card_number,:exp_month => Time.now.month,:exp_year => Time.now.year,:cvc => "314"}).id}
  context "with valid credit card" do
    let(:card_number) {4242424242424242}
    it "will return true for successfull?" do
      charge = StripeWrapper::Charge.create(amount: 999, card: token)
      expect(charge.successful?).to be_true
    end
  end
  
  context "with invalid credit card" do
    let(:card_number) {4000000000000002}
    it "will return false for successfull?" do
      charge = StripeWrapper::Charge.create(amount: 999, card: token)
      expect(charge.successful?).to be_false
    end
    it "will contain an error message" do
      charge = StripeWrapper::Charge.create(amount: 999, card: token)
      expect(charge.error_message).to eq("Your card was declined.")
    end
    
  end 
  
end

