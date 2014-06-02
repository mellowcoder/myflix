require 'spec_helper'

describe ForgotPasswordsController do

  describe "POST #create" do
    after {ActionMailer::Base.deliveries.clear}
    let(:forgetful_steve) {Fabricate(:user)}
    context "for a valid email" do
      before {post :create, email: forgetful_steve.email}
      it "redirects to the forgot password confirmation page" do
        expect(response).to redirect_to(forgot_password_confirmation_path)
      end
      it "sets the password reset token for the specific user" do
        expect(forgetful_steve.reload.password_reset_token).to_not be_blank
      end
      it "sends the password reset email" do
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end
      it "sends the email to the new users email address" do
        password_reset_email = ActionMailer::Base.deliveries.last
        expect(password_reset_email.to[0]).to eq(forgetful_steve.email)
      end
      it "sends a welcome email with the users full_name in the body" do
        password_reset_email = ActionMailer::Base.deliveries.last
        expect(password_reset_email.body).to include(forgetful_steve.password_reset_token)
      end
    end

    context "for a invalid email" do
      before {post :create, email: 'xyz'+forgetful_steve.email}
      it "redirects to the fogot password page" do
        expect(response).to redirect_to(forgot_password_path)
      end
      it "does not send out the reset password email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      it "sets error message" do
        expect(flash[:error]).not_to be_blank
      end
    end
    
    context "for a blank email" do
      before {post :create, email: ''}
      it "redirects to the fogot password page" do
        expect(response).to redirect_to(forgot_password_path)
      end
      it "does not send out the reset password email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      it "sets error message" do
        expect(flash[:error]).not_to be_blank
      end
    end
    
  end

  describe  "GET #edit" do
    let(:forgetful_steve) {Fabricate(:user)}
    context "for a valid token" do
      before do
        forgetful_steve.set_password_reset_token
        get :edit, id: forgetful_steve.password_reset_token
      end
      it "renders the password reset template" do
        expect(response).to render_template(:edit)
      end
      it "assigns @user" do
        expect(assigns(:user)).to eq(forgetful_steve)
      end
    end
    it "redirects to the invalid token page when a user can not be found for the token" do
      get :edit, id: SecureRandom.urlsafe_base64(36)
      expect(response).to redirect_to(invalid_token_path)
    end
  end
  
  describe "POST #update" do
    let(:forgetful_steve) {Fabricate(:user)}
    context "for a valid token and password" do
      before do
        forgetful_steve.set_password_reset_token
        patch :update, id: forgetful_steve.password_reset_token, password: "test1234"        
      end
      it "redirects to the sign in page" do
        expect(response).to redirect_to(sign_in_path)
      end
      it "sets the success flash message" do
        expect(flash[:success]).not_to be_blank
      end
      it "clears the password reset token" do
        expect(forgetful_steve.reload.password_reset_token).to be_blank
      end
      it "resets the users password" do
        expect(forgetful_steve.reload.authenticate('test1234')).to be_true
      end
    end
    context "for a valid token and an invalid password" do
      before do
        forgetful_steve.set_password_reset_token
        patch :update, id: forgetful_steve.password_reset_token, password: ""        
      end
      it "renders the reset password template" do
        expect(response).to render_template(:edit)
      end
      
    end

    it "redirects to the invalid token page when a user can not be found for the token" do
      patch :update, id: SecureRandom.urlsafe_base64(36), password: "test1234"        
      expect(response).to redirect_to(invalid_token_path)
    end


  end
  

end

