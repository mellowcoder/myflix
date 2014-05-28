require 'spec_helper'

describe FollowedRelationshipsController do

  context "with an authenticated user" do
    before {login_current_user}

    describe "GET #index" do
      it "assignes @followed_relations" do
        jane = Fabricate(:user)
        Fabricate(:relationship, follower: current_user, followed: jane)
        get :index
        expect(assigns(:followed_relations).count).to eq(1)
      end
      
      describe "DELETE #destroy" do
        it "redirects to followed followed people page" do
          jane = Fabricate(:user)
          followed_relation = Fabricate(:relationship, follower: current_user, followed: jane)
          delete :destroy, {id: followed_relation.id}
          expect(response).to redirect_to(:people)
        end
        
        it "deletes the relationship from the followed_relations" do
          jane = Fabricate(:user)
          followed_relation = Fabricate(:relationship, follower: current_user, followed: jane)
          delete :destroy, {id: followed_relation.id}
          expect(Relationship.count).to eq(0)
        end
        
        it "does not dlete the relation if the user is not the follower" do
          jane = Fabricate(:user)
          followed_relation = Fabricate(:relationship, follower: jane, followed: current_user)
          delete :destroy, {id: followed_relation.id}
          expect(Relationship.count).to eq(1)
        end
      end

      describe "POST #create" do
        let(:jane) {Fabricate(:user)}
        it "redirects to the peoples page" do
          post :create, {followed_id: jane.id}
          expect(response).to redirect_to(people_path)
        end
        it "adds a relationship for the followed" do
          post :create, {followed_id: jane.id}
          expect(current_user.followed_relations.first.followed).to eq(jane)
        end
        it "does not create a relationship if the followed is the same as the follower" do
          post :create, {followed_id: current_user.id}
          expect(Relationship.count).to eq(0)
        end
        it "does not create a relationship one already exist for this follower and followed" do
          Fabricate(:relationship, follower: current_user, followed: jane)
          post :create, {followed_id: jane.id}
          expect(Relationship.count).to eq(1)
        end
      end
      
    end
  end


  
  context "with an un-authenticated user" do
    describe "GET #index" do
      it_behaves_like "require_sign_in" do 
        let(:action) {get :index}
      end
    end

    describe "DELETE #destroy" do
      it_behaves_like "require_sign_in" do 
        let(:action) {delete :destroy, {id: 1}}
      end
    end
    
    describe "POST #create" do
      it_behaves_like "require_sign_in" do 
        let(:action) {post :create, {followed_id: 1}}
      end
    end
    
  end
  
end
