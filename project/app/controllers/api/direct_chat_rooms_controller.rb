class Api::DirectChatRoomsController < ApplicationController
  def index
    render plain: params[:user_id] + "'s direct chat rooms"
  end

  def show
    render plain: params[:user_id] + "'s direct chat room with " + params[:id]
  end

  def create
    render plain: params[:user_id] + " creates new chat room"
  end
end
