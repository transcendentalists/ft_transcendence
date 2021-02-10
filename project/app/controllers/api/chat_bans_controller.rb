class Api::ChatBansController < ApplicationController
  def index
    chat_bans = ChatBan.where(user_id: params[:user_id])
    render json: { chatBans: chat_bans }
  end

  def show
    chat_ban = ChatBan.find_by_user_id_and_banned_user_id(params[:user_id], params[:id])
    render json: { chatBan: chat_ban }
  end

  def create
    ChatBan.find_or_create_by(chatBanParams)
  end

  def destroy
    ChatBan.find_by_id(params[:id])&.destroy
  end

  private

  def chatBanParams
    params.permit(:user_id, :banned_user_id)
  end
end
