class Registration
  
  attr_reader :user, :charge
  
  def initialize(user_params, stripe_token)
    @user =  User.new(user_params)
    @stripe_token = stripe_token
    @card_charged = false
  end
  
  def save
    ActiveRecord::Base.transaction do
      @user.save!
      return charge_card!
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
    if (charge.successful?)
      @card_charged = true
    else
      @user.errors[:credit_card] = charge.error_message
      raise ActiveRecord::Rollback, charge.error_message
      return false
    end
  end
  
end


