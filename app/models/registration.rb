class Registration
  
  attr_reader :user
  
  def initialize(user_params, stripe_token)
    @user =  User.new(user_params)
    @stripe_token = stripe_token
    @card_charged = false
  end
  
  def save
    ActiveRecord::Base.transaction do
      @user.save!
      create_customer_with_plan!
      @user.update_attribute(:stripe_customer_id, @customer.stripe_customer_id)
      send_welcome_email
      return true
    end
  rescue
    return false
  end
  
  def card_charged?
    @card_charged
  end
  
  private

  def charge_card!
    @charge = StripeWrapper::Charge.create(amount: 999, card: @stripe_token)
    if (@charge.successful?)
      binding.pry
      @card_charged = true
    else
      @user.errors[:credit_card] = @charge.error_message
      raise ActiveRecord::Rollback, @charge.error_message
      return false
    end
  end
  
  def create_customer_with_plan!    
    @customer = StripeWrapper::CustomerWithPlan.create(card: @stripe_token, myflix_reference: "MyFlix_Customer_#{@user.id}")
    if (@customer.successful?)
      @card_charged = true
    else
      @user.errors[:credit_card] = @customer.error_message
      raise ActiveRecord::Rollback, @customer.error_message
      return false
    end
  end
  
  def send_welcome_email
    UserMailer.delay.welcome_email(user.id)
  end
  
end


