require 'spec_helper'

describe UsersController do

  describe "GET #show" do
    let(:user) {Fabricate(:user)}
    context "for an authenticated user" do
      before do
        Fabricate(:review, user: user)
        Fabricate(:queue_item, user: user)
        login_current_user
        get :show, id: user
      end
      
      it "assigns @user" do
        expect(assigns(:user)).to eq(user)
      end      
    end
    
    context "for an un-authenticated user" do
      it_behaves_like "require_sign_in" do 
        let(:action) {get :show, id: 1}
      end
    end 
  end
  
  describe "GET #new" do
    it "assigns @user" do 
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
    it "renders the new user template" do
      get :new
      expect(response).to render_template(:new)
    end
    it "assigns @user includes the invite if a valid invite token is provided" do
      invite = Fabricate(:invite)
      get :new, token: invite.token
      expect(assigns(:user).registration_invite).to eq(invite)
    end
    it "assigns @user includes the email address if a valid invite token is provided" do
      invite = Fabricate(:invite)
      get :new, token: invite.token
      expect(assigns(:user).email).to eq(invite.email)
    end
    it "does not assigns @invite if the included token invalid" do
      get :new, token: 'xyz'
      expect(assigns(:user).registration_invite).to be_blank
    end
    
  end
  
  describe "POST #create" do
    before do
      stub_stripe_customer_with_plan_as_successful
    end
    
    context "valid input" do
      it "redirects to the sign in page" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to(:sign_in)
      end
      it "delegates to the registration object and returns true" do
        Registration.any_instance.should_receive(:save).and_return(true)
        post :create, user: Fabricate.attributes_for(:user)
        
      end
      
     end
    
    context "invalid input" do
      before {post :create, user: {email: "test@example.com", full_name: "Test User", password: ""}}
      it "does not create a User" do
        post :create, user: {email: "test@example.com", full_name: "Test User", password: ""}
        expect(User.count).to eq(0)
      end
      it "renders the new template" do
        expect(response).to render_template(:new)
      end
      it "assigns @user" do
        post :create, user: {email: "test@example.com", full_name: "Test User", password: ""}
        expect(assigns(:user)).to be_a_new(User)
      end
      it "delegates to the registration object and returns false" do
        Registration.any_instance.should_receive(:save).and_return(false)
        post :create, user: {email: "test@example.com", full_name: "Test User", password: ""}      end
    end
  end
  
end
