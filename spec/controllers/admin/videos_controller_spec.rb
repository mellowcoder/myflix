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


  describe "POST #create" do
    it_behaves_like "require_sign_in" do 
      let(:action) {post :create, video: {title: "Test Video", description: "All about this video"}}
    end
    it_behaves_like "require_admin" do 
      let(:action) {post :create, video: {title: "Test Video", description: "All about this video"}}
    end
    
    context "for and authenticated admin" do
      before do
        admin_user = Fabricate(:user, admin: true)
        login_current_user(admin_user)
      end
      
      context "for valid inputs" do
        before do 
          Fabricate(:category)
          post :create, video: {title: "Test Video", description: "All about this video", category_id: Category.first.id}
        end
        it "creates a new video" do
          expect(Video.count).to eq(1)
        end
        it "redirects to the add video page" do
          expect(response).to redirect_to(new_admin_video_path)
        end
        it "sets the flash success message" do
          expect(flash[:success]).not_to be_blank
        end
        
      end
      context "for invalid inputs" do
        before do
          Fabricate(:category)
          post :create, video: {title: "", description: "All about this video", category_id: Category.first.id}
        end
        it "does not creates a new video" do
          expect(Video.count).to eq(0)
        end
        it "renders the new templage" do
          expect(response).to render_template(:new)
        end
        it "assigns @video to a new video instance" do
          expect(assigns(:video)).to be_a_new(Video)
        end
        it "sets the flash error message" do
          expect(flash[:error]).to be_present
        end
        
      end
      

    end
  end
  


end
