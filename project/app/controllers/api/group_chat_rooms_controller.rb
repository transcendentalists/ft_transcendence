class Api::GroupChatRoomsController < ApplicationController
  def index
    if params[:for] == 'my_group_chatroom_list'
      group_chatrooms = GroupChatRoom.list_associated_with_current_user(params[:id])
    else
      if params[:room_type]
        group_chatrooms = GroupChatRoom.list_filtered_by_type(params[:room_type])
      else
        group_chatrooms = GroupChatRoom.list_all
      end
    end
    render :json => { group_chatrooms: group_chatrooms }
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
