require 'spec_helper'

describe Admin::PaymentsController do
  before {3.times {Fabricate(:payment)}}

  describe "GET #index" do
    it_behaves_like "require_sign_in" do 
      let(:action) {get :index}
    end
    it_behaves_like "require_admin" do 
      let(:action) {get :index}
    end
    context "for an authorized admin" do
      before do
        admin_user = Fabricate(:user, admin: true)
        login_current_user(admin_user)
        get :index
      end
      it "assignes @payments" do
        expect(assigns(:payments)).to eq(Payment.all)
      end
    end
  
  end 
  
  
  
end
