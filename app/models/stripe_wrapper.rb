module StripeWrapper
  
  class Charge
  
    def initialize(response, status)
      @response = response
      @status = status
    end  
  
    def self.create(options={})
      StripeWrapper.set_api_key
      begin
        response = Stripe::Charge.create(amount: options[:amount], currency: "usd", card: options[:card], description: options[:description])
        new(response, :success)
      rescue Stripe::CardError => error
        new(error, :error)
      end
    end
    
    def successful?
      @status == :success ? true : false
    end
    
    def error_message
      @response.message
    end
  end
  

  class CustomerWithPlan
    
    def initialize(response, status)
      @response = response
      @status = status
    end  
    
    def self.create(options={})
      StripeWrapper.set_api_key
      begin
        response = Stripe::Customer.create(:card => options[:card], :plan => "myflix_monthly", :description => options[:myflix_reference])
        new(response, :success)
      rescue Stripe::CardError => error
        new(error, :error)
      end
    end
    
    def successful?
      @status == :success ? true : false
    end
    
    def error_message
      @response.message
    end
    
  end
  

  def self.set_api_key
    Stripe.api_key = Rails.application.secrets.stripe_secret_key
  end
  
  def self.get_published_key
    Rails.application.secrets.stripe_published_key
  end
    
end

