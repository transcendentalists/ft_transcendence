class Api::GroupChatMembershipsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :destroy ]

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
    # TODO: 나간 멤버가 오너라면 다른 멤버를 오너로 만들 것
    params = destroy_params

    membership = GroupChatMembership.find_by_group_chat_room_id_and_user_id(params[:group_chat_room_id], params[:id])
    return render_error("NOT FOUND", "해당하는 챗룸/유저 정보가 없습니다.", "404") if membership.nil?

    return render_error("NOT AUTHORIZED", "권한이 없는 유저입니다.", "403") unless membership.is_authorized_user_to_destroy(@current_user)

    membership.destroy

    return render_error("FAILED TO DESTROY", "멤버십 삭제를 실패했습니다.", "500") unless membership.destroyed?
    render plain: "success to destroy chat room membership"
  end

  private

  def destroy_params
    params.require(:group_chat_room_id)
    params.require(:id)
    params.permit(:group_chat_room_id, :id)
  end

  def check_headers_and_find_current_user
    if !request.headers['HTTP_CURRENT_USER']
      return render_error("NOT VALID HEADERS", "필요한 요청 Header가 없습니다.", "400")
    end
    @current_user = User.find_by_id(request.headers['HTTP_CURRENT_USER'])
    if @current_user.nil?
      return render_error("NOT VALID HEADERS", "요청 Header의 값이 유효하지 않습니다.", "400")
    end
  end

end
