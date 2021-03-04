class Api::FriendshipsController < ApplicationController
  def index
    friends_list = User.find_by_id(params[:user_id])&.friends_list(params)
    render json: { friendships: friends_list }
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
