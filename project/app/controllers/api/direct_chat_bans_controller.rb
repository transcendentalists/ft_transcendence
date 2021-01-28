class Api::DirectChatBansController < ApplicationController
  def index
    render plain: params[:user_id] + "'s direct chat ban list"
  end

  def create
    render plain: params[:user_id] + " create new chat ban"
  end

  def destroy
    render plain: params[:user_id] + " destroy chat ban " + params[:id]
  end
end
