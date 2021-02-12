class Api::DirectChatRoomsController < ApplicationController
  def index
    render plain: params[:user_id] + "'s direct chat rooms"
  end

  def show
    room = User.find(params[:user_id]).direct_chat_rooms.joins(:memberships).where(memberships: {user_id: params[:id]}).first
    if room.nil?
      room = DirectChatRoom.create()
      [params[:user_id], params[:id]].each { |user_id| DirectChatMembership.create(direct_chat_room_id: room.id, user_id: user_id) }
    end
    render :json => {
      chat_messages: room ? room.messages : nil
    }
  end

  def create
    render plain: params[:user_id] + " creates new chat room"
  end
end
