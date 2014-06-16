require 'spec_helper'

describe "Failed Charge" do
  before {ActionMailer::Base.deliveries.clear}
  let(:event_data) do 
    {
      "id" => "evt_104Eak4WCz9FSXwSOGkdZiGz",
      "created" => 1402953798,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_104Eak4WCz9FSXwS9GePbMx4",
          "object" => "charge",
          "created" => 1402953798,
          "livemode" => false,
          "paid" => false,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_104Eak4WCz9FSXwSFP09Wnku",
            "object" => "card",
            "last4" => "0341",
            "type" => "Visa",
            "exp_month" => 6,
            "exp_year" => 2015,
            "fingerprint" => "4iwceQpbJEiJpnfu",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "customer" => "cus_4DW0ITmxrKqioh"
          },
          "captured" => false,
          "refunds" => [],
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_4DW0ITmxrKqioh",
          "invoice" => nil,
          "description" => "testing failure",
          "dispute" => nil,
          "metadata" => {},
          "statement_description" => nil,
          "receipt_email" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_4EakqBAdZo2WBo"
    }
  end
  
  it "flags the user to prevent access", :vcr do
    customer_with_bad_credit  = Fabricate(:user, stripe_customer_id: 'cus_4DW0ITmxrKqioh')
    post "/stripe_events", event_data
    expect(customer_with_bad_credit.reload.active?).to be_false
  end
  
  it "sends the user a charge failure notification email", :vcr  do
    customer_with_bad_credit  = Fabricate(:user, stripe_customer_id: 'cus_4DW0ITmxrKqioh')
    post "/stripe_events", event_data
    expect(ActionMailer::Base.deliveries).to_not be_empty
  end
  
end
