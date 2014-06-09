class Registration
  
  attr_reader :user, :stripe_token
  
  def initialize(params)
    Stripe.api_key = "sk_test_BQokikJOvBiI2HlWgH4olfQ2"
    @user =  User.new(user_params(params))
    @stripe_token = params[:stripeToken]
  end
  
  def save
    ActiveRecord::Base.transaction do
      begin
        @user.save!
        charge = Stripe::Charge.create(
          :amount => 999, # amount in cents, again
          :currency => "usd",
          :card => stripe_token
          )
          binding.pry
      rescue Stripe::CardError => e
        # binding.pry
        @user.errors[:base] << "The card has been declined"
        return false
      rescue => e
        # binding.pry
        raise ActiveRecord::Rollback, "Error creating registration"
        @user.errors[:base] << "Error creating registration"
        return false
      end
    end
  end
  
  private
  
  def user_params(params)
    params.require(:user).permit(:full_name, :email, :password, :invite_id)
  end
  
  
end


