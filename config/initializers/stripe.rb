Stripe.api_key = Rails.application.secrets.stripe_secret_key

StripeEvent.configure do |events|
  
  events.subscribe 'charge.succeeded' do |event|
    user = User.find_by_stripe_customer_id(event.data.object.customer)
    Payment.create(user: user, amount: event.data.object.amount, stripe_reference_id: event.data.object.id)
  end
  
  events.subscribe 'charge.failed' do |event|
    user = User.find_by_stripe_customer_id(event.data.object.customer)
    user.deactivate!
    UserMailer.delay.account_deactivated_email(user.id)
  end

end