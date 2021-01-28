class Api::GroupChatMembershipsController < ApplicationController
  def index
    render plain: params[:group_chat_room_id] + " memberships index"
  end

  def create
    render plain: params[:group_chat_room_id] + " creates group chat membership"
  end

  def update
    render plain: params[:group_chat_room_id] + " group chat room updates " + params[:id] + " membership"
  end

  def destroy
    render plain: params[:group_chat_room_id] + " group chat room destroy " + params[:id] + " membership"
  end
end
