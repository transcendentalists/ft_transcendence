class Api::ChatBansController < ApplicationController
  def index
    render plain: chatBanParams[:user_id] + "'s chat ban list"
  end

  def create
    ChatBan.newChatBan(chatBanParams);
  end

  def destroy
    render plain: params[:user_id] + " destroy chat ban " + params[:id]
  end

  private

  def chatBanParams
    params.permit(:user_id, banned_user: [:id])
  end
end
