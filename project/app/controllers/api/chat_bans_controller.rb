class Api::ChatBansController < ApplicationController
  def index
    chat_bans = ChatBan.where(user_id: params[:user_id])
    render json: { chatBans: chat_bans }
  end

  def show
    chat_ban = ChatBan.where(user_id: params[:user_id]).find_by_banned_user_id(params[:banned_user_id])
    redner json: { chatBan: chat_ban }
  end

  def create
    ChatBan.newChatBan(chatBanParams)
  end

  def destroy
    render plain: params[:user_id] + ' destroy chat ban ' + params[:id]
  end

  private

  def chatBanParams
    params.permit(:user_id, banned_user: [:id])
  end
end
