require 'spec_helper'

describe QueueItemsController do

  context "with an authenticated user" do
    before { login_current_user }
    describe "GET #index" do
      
      before do
        Fabricate(:queue_item, user: current_user, position: 2)
        Fabricate(:queue_item, user: current_user, position: 1)
      end
      
      it "assignes @queue_items" do
        get :index
        expect(assigns(:queue_items).count).to eq(2)      
      end
      it "includes all queue_items for the current user" do
        get :index
        expect(assigns(:queue_items)).to match_array(current_user.queue_items)      
      end
      it "does not include any queue items for other users" do
        other_user_item = Fabricate(:queue_item)
        get :index
        expect(assigns(:queue_items)).not_to include(other_user_item)      
      end
      it "it renders the index page" do
        get :index
        expect(response).to render_template(:index)
      end
      it "displays queue items ordered by position" do
        get :index
        expect(assigns(:queue_items).first.position).to eq(1) 
        expect(assigns(:queue_items).last.position).to eq(2) 
      end
      
    end
    
    describe "POST #create" do
      let(:video) {Fabricate(:video)}
      it "adds the video to the current users queue if it does not already exist" do
        post :create, {video_id: video.id}
        expect(current_user.queue_items.count).to eq(1)
      end
      it "sets the position of the item to the end of the queue" do
        Fabricate(:queue_item, user: current_user)
        post :create, {video_id: video.id}
        expect(current_user.queue_items.order(:position).last.position).to eq(current_user.queue_items.count)
      end
      it "redirects to the My Queue page" do
        post :create, {video_id: video.id}
        expect(response).to redirect_to(:my_queue)
      end
      it "creates a queue item that is associated with this video" do
        post :create, {video_id: video.id}
        expect(current_user.queue_items.first.video).to eq(video)
      end
      it "does not add the video if it is already in the queue" do
        Fabricate(:queue_item, video: video, user: current_user)
        post :create, {video_id: video.id}
        expect(current_user.queue_items.count).to eq(1)
      end
    end
    
    describe "DELETE #destroy" do
      it "redirects to the my queue page" do
        item = Fabricate(:queue_item, user: current_user)
        delete :destroy, {id: item.id}
        expect(response).to redirect_to(:my_queue)
      end
      it "deletes the item from the queue" do
        item = Fabricate(:queue_item, user: current_user)
        delete :destroy, {id: item.id}
        expect(QueueItem.count).to eq(0)
      end
      it "does not delete the item if it is not in the current users queue" do
        item = Fabricate(:queue_item)
        delete :destroy, {id: item.id}
        expect(QueueItem.count).to eq(1)
      end
      it "should normalize the remaining items whenever an item is removed" do
        item1 = Fabricate(:queue_item, user: current_user, position: 1)
        item2 = Fabricate(:queue_item, user: current_user, position: 2)
        delete :destroy, {id: item1.id}
        expect(item2.reload.position).to eq(1)
      end
      
    end
    
    describe "PUT #update_queue" do
      context "with valid inputs" do
        let(:item_a) {Fabricate(:queue_item, user: current_user, position: 1)}
        let(:item_b) {Fabricate(:queue_item, user: current_user, position: 2)}
        it "redirects to the my queue page" do
          put :update_queue, queue_items: {item_a.id => {position: 2}, item_b.id => {position: 1}}
          expect(response).to redirect_to(my_queue_path)
        end
      
        it "saves the queue items with updated positions" do
          put :update_queue, queue_items: {item_a.id => {position: 2}, item_b.id => {position: 1}}
          expect(current_user.queue_items).to eq([item_b, item_a])
        end
      
        it "resets the queue postions to be in sequential" do
          put :update_queue, queue_items: {item_a.id => {position: 7}, item_b.id => {position: 3}}
          expect(current_user.queue_items.map(&:position)).to eq([1, 2])        
        end        
      end
      
      context "with invalid inputs" do
        let(:item_a) {Fabricate(:queue_item, user: current_user, position: 1)}
        let(:item_b) {Fabricate(:queue_item, user: current_user, position: 2)}
        it "redirects to the my queue page" do
          put :update_queue, queue_items: {item_a.id => {position: 1}, item_b.id => {position: 2.5}}
          expect(response).to redirect_to(my_queue_path)
        end
        it "sets the flash error message" do
          put :update_queue, queue_items: {item_a.id => {position: 1}, item_b.id => {position: 2.5}}
          expect(flash[:error]).to be_present
        end
        it "does not change the queue items" do
          item_c = Fabricate(:queue_item, user: current_user, position: 3)
          put :update_queue, queue_items: {item_a.id => {position: 2}, item_b.id => {position: 1}, item_c.id => {position: 3.5}}
          expect(item_a.reload.position).to eq(1)
        end
        
      end

      context "with queue item that does not belong to the current user" do
        let(:item_a) {Fabricate(:queue_item, user: current_user, position: 1)}
        let(:item_b) {Fabricate(:queue_item, user: current_user, position: 2)}
        it "should not save the other users queue item" do
          tom = Fabricate(:user)
          toms_item1 = Fabricate(:queue_item, user: tom, position: 1)
          toms_item2 = Fabricate(:queue_item, user: tom, position: 2)
          put :update_queue, queue_items: {toms_item2.id => {position: 1}, item_a.id => {position: 2}, item_b.id => {position: 3}}
          expect(toms_item2.reload.position).to eq(2)        
        end 
        
      end
      
    end
    
  end
  
  context "with an unauthenticated user" do

    describe "GET #index" do
      it "redirects to the sign in page" do
        get :index
        expect(response).to redirect_to(sign_in_path)
      end
    end

    describe "POST #create" do
      it "redirects to the sign in page" do
        video = Fabricate(:video)
        post :create, {video_id: video.id}
        expect(response).to redirect_to(sign_in_path)
      end
    end

    describe "DELETE #destroy" do
      it "redirects to the sign in page" do
        item = Fabricate(:queue_item)
        delete :destroy, {id: item.id}
        expect(response).to redirect_to(sign_in_path)
      end
    end
    
    describe "PUT #update_queue" do
      it "redirects to the sign in page" do
        item = Fabricate(:queue_item)
        put :update_queue, queue_items: {item.id => {position: 2}}
        expect(response).to redirect_to(sign_in_path)
      end
    end
  end
  
end
