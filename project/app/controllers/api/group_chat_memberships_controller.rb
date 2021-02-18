class Api::GroupChatMembershipsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :destroy ]

  def index
    render plain: params[:group_chat_room_id] + " memberships index"
  end

  def create
    render plain: params[:group_chat_room_id] + " creates group chat membership"
  end

  def update
    params = update_params
    render_error("BAD REQUEST", "권한이 없거나 형식이 잘못된 요청입니다.", 400) if params.nil?
    
    membership = params[:member_membership]
    membership = membership.update_mute(params) unless params[:mute].nil?
    membership = membership&.update_position(params) unless params[:position].nil?

    if membership
      render :json => { group_chat_membership: membership }
    else
      render_error("BAD REQUEST", "권한이 없거나 형식이 잘못된 요청입니다.", 400)
    end
  end

  def destroy
    # TODO: 
    # 1. 나간 멤버가 오너라면 
    #   1) 다른 멤버를 오너로 만들 것 (DONE) 
    #   2) 다른 멤버가 오너로 바뀌었다는 사실을 알릴 것
    # 2. 룸에 인원이 없으면 룸을 삭제할 것. (DONE)
    params = destroy_params

    memberships = GroupChatMembership.where(group_chat_room_id: params[:group_chat_room_id])
    return render_error("NOT FOUND", "해당하는 챗룸 정보가 없습니다.", "404") if memberships.empty?

    membership = memberships.find_by_user_id(params[:id])
    return render_error("NOT FOUND", "챗룸에 유저 정보가 없습니다.", "404") if membership.nil?
    return render_error("NOT AUTHORIZED", "권한이 없는 유저입니다.", "403") unless membership.is_authorized_user_to_destroy(@current_user)

    make_another_member_an_owner memberships if membership.position == "owner"
    if membership.room.users.count == 1
      membership.room.destroy 
    else
      membership.destroy
    end

    return render_error("FAILED TO DESTROY", "멤버십 삭제를 실패했습니다.", "500") unless membership.destroyed?
    render plain: "success to destroy chat room membership"
  end

  private

  def update_params
    admin_membership = GroupChatMembership.find_by_user_id_and_group_chat_room_id(params[:admin_id], params[:group_chat_room_id])
    member_membership = GroupChatMembership.find_by_user_id_and_group_chat_room_id(params[:member_id], params[:group_chat_room_id])
    return nil if admin_membership.nil? || member_membership.nil?
    return nil if params[:mute].nil? && params[:position].nil?
    { admin_membership: admin_membership, member_membership: member_membership, mute: params[:mute], position: params[:position]}
  end

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

  def make_another_member_an_owner(memberships)
    admin = memberships.find_by_position("admin")
    return admin.update_position_as("owner") unless admin.nil?

    member = memberships.find_by_position("member")
    return member.update_position_as("owner") unless member.nil?
  end

end
