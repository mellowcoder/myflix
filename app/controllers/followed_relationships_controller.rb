class FollowedRelationshipsController < ApplicationController
  before_action :require_user
  
  def index
    @followed_relations = current_user.followed_relations
  end
  
  def destroy
    relationship = Relationship.find(params[:id])
    relationship.destroy if relationship.follower == current_user
    redirect_to people_path
  end
  
end
