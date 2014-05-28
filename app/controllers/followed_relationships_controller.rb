class FollowedRelationshipsController < ApplicationController
  before_action :require_user
  
  def index
    @followed_relations = current_user.followed_relations
  end
  
  def create
    followed_user = User.find(params[:followed_id])
    Relationship.create(follower: current_user, followed: followed_user) if current_user.can_follow?(followed_user)
    redirect_to people_path
  end
  
  def destroy
    relationship = Relationship.find(params[:id])
    relationship.destroy if relationship.follower == current_user
    redirect_to people_path
  end

end
