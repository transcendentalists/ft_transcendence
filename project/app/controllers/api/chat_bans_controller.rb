class Api::ChatBansController < ApplicationController
  def index
    begin
      chat_bans = ChatBan.where(user_id: params[:user_id])
      render json: { chat_bans: chat_bans }
    rescue => e
      perror e
      render_error :NotFound
    end
  end

  def show
    begin
      chat_ban = ChatBan.find_by_user_id_and_banned_user_id(params[:user_id], params[:id])
      render json: { chat_bans: chat_ban }
    rescue => e
      perror e
      render_error :NotFound
    end
  end

  def create
    begin
      ChatBan.find_or_create_by(chatBanParams)
    rescue => e
      perror e
      render_error :Conflict
    end
  end

  def destroy
    begin
      ChatBan.find_by_id(params[:id])&.destroy
      head :no_content, status: 204
    rescue => e
      perror e
      render_error :Conflict
    end
  end

  private

  def chatBanParams
    params.permit(:user_id, :banned_user_id)
  end
end
