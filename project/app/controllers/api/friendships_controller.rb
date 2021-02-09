class Api::FriendshipsController < ApplicationController
  def index
    friends = User.where(id: Friendship.where(user_id: params[:user_id]).select(:friend_id))
    friends = User.select_by_query(friends, params)
    render json: {friendships: friends}
  end

  def create
    friendship = Friendship.find_or_create_by(user_id: params[:user_id], friend_id: params[:friend_id])
    render json: {friendships: {id: friendship.id}}
  end

  def destroy
    friendship = Friendship.find_by_user_id_and_friend_id(params[:user_id], params[:id])
    friendship&.destroy
  end
end
