class Api::FriendshipsController < ApplicationController
  def index
    render plain: params[:user_id] +"'s friends index"
  end

  def create
    render plain: params[:user_id] + "'s new friends!"
  end

  def destroy
    render plain: params[:user_id] + +" destory " + params[:id] +" friends!"
  end
end
