class Api::FriendshipsController < ApplicationController
  def index
    friends = User.where(id: Friendship.where(user_id: params[:user_id]).select(:friend_id))
    friends = User.select_by_query(friends, params)
    render json: {friendships: friends}
  end

  def create
    render plain: params[:user_id] + "'s new friends!"
  end

  def destroy
    render plain: params[:user_id] + +" destory " + params[:id] +" friends!"
  end
end
