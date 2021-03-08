class Api::GuildInvitationsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :create, :destroy ]

  def index
    guild_invitations = GuildInvitation.for_user_index(params[:user_id])
    render json: { guild_invitations: guild_invitations }
  end

  def show
    render plain: "GuildInvitation show"
  end

  def create
    return render_error("길드 초대 실패", "권한이 없습니다.", 403) if @current_user.id != params[:user_id].to_i
    begin
      guild_invitation = GuildInvitation.create!(create_params)
    rescue ActiveRecord::RecordInvalid => e
      key =  e.record.errors.attribute_names.first
      error_message = e.record.errors.messages[key].first
      return render_error("길드 초대 실패", error_message, 400)
    rescue
      return render_error("길드 초대 실패", "잘못된 요청입니다.", 400)
    else
      render json: { guild_invitation: guild_invitation.id }
    end
  end

  def destroy
    guild_invitation = GuildInvitation.find_by_id(params[:id])
    return render_error("길드 초대 거부 실패", "존재하지 않는 길드 초대입니다.", 400) if guild_invitation.nil?
    return render_error("길드 초대 거부 실패", "거부 권한이 없습니다.", 400) if @current_user.id != guild_invitation.invited_user_id
    guild_invitation.destroy
    head :no_content, status: 204
  end

  private
  def create_params
    params.permit(:user_id, :invited_user_id, :guild_id)
  end
end
