class Api::GroupChatRoomsController < ApplicationController
  def index
    render plain: "group chat rooms index"
  end

  def create
    render plain: "group chat room create"
  end

  def show
    render plain: params[:id] + " group chat room show"
  end

  def update
    render plain: params[:id] + " group chat room update"
  end

  def destroy
    render plain: params[:id] + " group chat room destroy"
  end
end
