class Admin::PaymentsController < Admin::AdministrationController

  def index
    @payments = Payment.all
  end
  
end
