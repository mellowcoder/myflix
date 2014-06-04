require 'spec_helper'

describe Admin::VideosController do

  describe "GET #new" do
    it_behaves_like "require_sign_in" do 
      let(:action) {get :new}
    end

    it_behaves_like "require_admin" do 
      let(:action) {get :new}
    end

    context "for an authenticated Admin user" do
      before do
        admin_user = Fabricate(:user, admin: true)
        login_current_user(admin_user)
      end
      it "assignes @videos as a new video instance" do
        get :new
        expect(assigns(:video)).to be_a_new(Video)
      end
    end
    
    
  end
end
