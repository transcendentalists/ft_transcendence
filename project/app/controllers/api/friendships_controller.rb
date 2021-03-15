class Api::FriendshipsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :index, :create, :destroy ]

  def index
    begin
      friends_list = @current_user.friends_list(params)
      render json: { friendships: friends_list }
    rescue => e
      perror e
      render_error :NotFound
    end
  end

  def create
    begin
      friendship = Friendship.find_or_create_by!(user_id: params[:user_id], friend_id: params[:friend_id])
      render json: { friendship: {id: friendship.id} }
    rescue => e
      perror e
      render_error :Conflict
    end
  end

  def destroy
    begin
      friendship = Friendship.find_by_user_id_and_friend_id(params[:user_id], params[:id])
      friendship.destroy!
      head :no_content, status: 204
    rescue => e
      perror e
      render_error :Conflict
    end
  end
end
