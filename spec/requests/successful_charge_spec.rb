require 'spec_helper'

describe "Successful Charge" do
  let(:event_data) do 
    {
      "id" => "evt_104ETl4WCz9FSXwSTZJoastI",
      "created" => 1402927774,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_104ETl4WCz9FSXwSA2V3SUXz",
          "object" => "charge",
          "created" => 1402927774,
          "livemode" => false,
          "paid" => true,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_104ETl4WCz9FSXwSnYXsdulC",
            "object" => "card",
            "last4" => "4242",
            "type" => "Visa",
            "exp_month" => 6,
            "exp_year" => 2014,
            "fingerprint" => "YRa6DuAXsy7Sh7jc",
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
            "customer" => "cus_4ETl88MRyzYold"
          },
          "captured" => true,
          "refunds" => [],
          "balance_transaction" => "txn_104ETl4WCz9FSXwSnuEqL7T2",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_4ETl88MRyzYold",
          "invoice" => "in_104ETl4WCz9FSXwStttNtHYO",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {},
          "statement_description" => "MyFlix Sub",
          "receipt_email" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_4ETl8uAlMjBjh1"
    }
  end
  
  
  it "creates a new payment record", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end
  
  it "creates a payment associated with the user", :vcr do
    user = Fabricate(:user, stripe_customer_id: "cus_4ETl88MRyzYold")
    post "/stripe_events", event_data
    expect(Payment.last.user).to eq(user)
  end
  
  it "creates the payment with the correct amount", :vcr do
    Fabricate(:user, stripe_customer_id: "cus_4ETl88MRyzYold")
    post "/stripe_events", event_data
    expect(Payment.last.amount).to eq(999)
  end
  
  it "creates the payment with the stripe_reference_id", :vcr do
    Fabricate(:user, stripe_customer_id: "cus_4ETl88MRyzYold")
    post "/stripe_events", event_data
    expect(Payment.last.stripe_reference_id).to eq("ch_104ETl4WCz9FSXwSA2V3SUXz")
  end

end
