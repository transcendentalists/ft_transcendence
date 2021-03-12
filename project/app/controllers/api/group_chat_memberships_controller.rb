class Api::GroupChatMembershipsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :update, :destroy ]

  def update
    begin
      membership = GroupChatMembership.find(params[:id])
      membership.update_by_params!({by: @current_user, params: update_params})
    rescue GroupChatMembershipError => e
      return render_error("UPDATE FAILURE", e.message, e.status_code)
    rescue
      return render_error("UPDATE FAILURE", "업데이트에 실패하였습니다.", 400)
    end
    render :json => { group_chat_membership: membership }
  end

  def checkBanTime!
    return if params[:ban_time] == ""
    ban_time = Integer(params[:ban_time])
    raise ArgumentError if ban_time < 0 || ban_time > 10000
  end

  def destroy
    membership = GroupChatMembership.find_by_id(params[:id])
    return render_error("NOT FOUND", "챗룸에 유저 정보가 없습니다.", "404") if membership.nil?
    return render_error("NOT AUTHORIZED", "권한이 없는 유저입니다.", "403") unless membership.can_be_destroyed_by?(@current_user)
    room = membership.room
    begin
      checkBanTime!
      room.with_lock do
        if room.active_member_count == 1
          room.destroy
        else
          room.make_another_member_owner! if membership.position == "owner"
          membership.set_ban_time_from_now({ min: params[:ban_time].to_i }) unless membership.current_user?(@current_user)
          membership.update_position!("ghost")
        end
      end
    rescue ArgumentError
      return render_error("BAD REQUEST", "밴 타임은 0과 10000 사이의 수로 입력해야 합니다.", "400")
    rescue
      return render_error("FAILED TO DESTROY", "멤버십 삭제를 실패했습니다.", "500")
    end

    head :no_content, status: 204
  end

  private
  def update_params
    params.require(:group_chat_membership) unless current_user_is_admin_or_owner?
    {
      id: params[:id],
      mute: params[:mute],
      position: params[:position]
    }
  end

end
