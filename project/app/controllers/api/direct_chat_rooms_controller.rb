class Api::DirectChatRoomsController < ApplicationController
  def index
    render plain: params[:user_id] + "'s direct chat rooms"
  end

  def show
    symbol = [params[:user_id].to_i, params[:id].to_i].sort.join('+')
    room = DirectChatRoom.find_by_symbol(symbol)
    if room.nil?
      room = DirectChatRoom.create(symbol: symbol)
      [params[:user_id], params[:id]].each { |user_id|
        DirectChatMembership.create(
          direct_chat_room_id: room.id,
          user_id: user_id,
        )
      }
  end
    render :json => {
      chat_messages: room ? room.messages.last(20) : nil
    }
  end

  def create
    render plain: params[:user_id] + " creates new chat room"
  end
end
