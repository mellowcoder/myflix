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
  end
  
  describe "POST #create" do
    after {ActionMailer::Base.deliveries.clear}
    context "valid input" do
      before {post :create, user: Fabricate.attributes_for(:user)}
      it "creates a new user" do
        expect(User.count).to eq(1)
      end
      it "redirects to the sign in page" do
        expect(response).to redirect_to(:sign_in)
      end
      
      it "sends a welcome email when a new user is created" do
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end
      
      it "sends the email to the new users email address" do
        invite_email = ActionMailer::Base.deliveries.last
        expect(invite_email.to[0]).to eq(User.last.email)
      end
      
      it "sends a welcome email with the users full_name in the body" do
        invite_email = ActionMailer::Base.deliveries.last
        expect(invite_email.body).to include(User.last.full_name)
      end
      
      
    end
    
    context "invalid input" do
      before {post :create, user: {email: "test@example.com", full_name: "Test User", password: ""}}
      it "does not create a User" do
        expect(User.count).to eq(0)
      end
      it "renders the new template" do
        expect(response).to render_template(:new)
      end
      it "assigns @user" do
        expect(assigns(:user)).to be_a_new(User)
      end
      it "does not send a welcome email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      
    end
  end
  
end
