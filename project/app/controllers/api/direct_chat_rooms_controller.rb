class Api::DirectChatRoomsController < ApplicationController
  include Api::DirectChatRoomsHelper

  def show
    begin
      symbol = get_symbol(params[:user_id], params[:id])
      room = DirectChatRoom.find_by_symbol(symbol)
      if room.nil?
        ActiveRecord::Base.transaction do
          room = DirectChatRoom.create!(symbol: symbol)
          room.create_memberships_by_ids!(params[:user_id], params[:id])
        end
      end
      render json: { chat_messages: room&.messages.last(20) }
    rescue ServiceError => e
      perror e
      render_error(e.type, e.message)
    rescue => e
      perror e
      render_error(:Conflict)
    end
  end

end
