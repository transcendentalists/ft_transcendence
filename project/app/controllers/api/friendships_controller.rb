class Api::FriendshipsController < ApplicationController
  def index
    # friends = User.select_by_query(friends, params)
    friends_list = User.find_by_id(params[:user_id])&.friends_list(params)
    render json: { friendships: friends_list }
  end
  # /api/
  def create
    render plain: params[:user_id] + "'s new friends!"
  end

  def destroy
    render plain: params[:user_id] + +" destory " + params[:id] +" friends!"
  end
end
