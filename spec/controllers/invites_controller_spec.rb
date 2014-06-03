require 'spec_helper'

describe InvitesController do
  
  describe "GET #new" do
    it_behaves_like "require_sign_in" do 
      let(:action) {get :new}
    end
    context "user is loged in" do
      before { login_current_user }
      it "assigns a new invite to @invite" do
        get :new
        expect(assigns(:invite)).to be_a_new(Invite)
      end
    end
  end

  describe "POST #create" do
    before {ActionMailer::Base.deliveries.clear}
    
    it_behaves_like "require_sign_in" do 
      let(:action) {get :new}
    end
    
    context "for valid inputs" do
      before do
        login_current_user
        post :create, invite: {name: 'Sally Fields', email: 'sfileds@stars.com', message: 'This is a great site', user: current_user}
      end
      it "redirects to the invite confirmed page" do
        expect(response).to redirect_to(invite_confirmed_path)
      end
      it "creates an invite record for the friend" do
        expect(Invite.last.email).to eq('sfileds@stars.com')
      end
      it "sends an email to the friend" do
        invite_email = ActionMailer::Base.deliveries.last
        expect(invite_email.to[0]).to eq('sfileds@stars.com')
      end
      it "sends an invite email with the users name in the body" do
        invite_email = ActionMailer::Base.deliveries.last
        expect(invite_email.body).to include(Invite.last.name)
      end
      it "sends an invite email with the friends full_name in the body" do
        invite_email = ActionMailer::Base.deliveries.last
        expect(invite_email.body).to include(current_user.password_reset_token)
      end
      
    end
    
    context "for invalid inputs" do
      before do
        login_current_user
        post :create, invite: {name: '', email: 'sfileds@stars.com', message: 'This is a great site', user: current_user}
      end
      it "renders the new page" do
        expect(response).to render_template(:new)
      end
      it "does not create an invite" do
        expect(Invite.count).to eq(0)
      end
      it "does not send the invitation email" do
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
      
    end
    
    
  end
  
end
