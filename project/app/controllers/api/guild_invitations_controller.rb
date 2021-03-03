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
    user = User.find_by_id(params[:user_id])
    invited_user = User.find_by_id(params[:invited_user_id])

    return render_error("Bad request", "유효하지 않은 요청입니다.", 400) if @current_user.id != user&.id
    return render_error("길드 초대 실패", "당신은 가입된 길드가 없습니다.", 400) if user.in_guild.nil?
    return render_error("길드 초대 실패", "당신은 초대 권한이 없습니다.", 400) if user.guild_membership.position == "member"
    return render_error("길드 초대 실패", "해당 유저가 존재하지 않습니다.", 400) if invited_user.nil?
    return render_error("길드 초대 실패", "해당 유저는 가입된 길드가 있습니다.", 400) unless invited_user.in_guild.nil?
    guild_invitation = GuildInvitation.where(user_id: user.id, invited_user_id: invited_user.id, guild_id: user.in_guild.id).first
    return render_error("길드 초대 실패", "당신이 보낸 길드 초대가 존재합니다.", 400) unless guild_invitation.nil?

    guild_invitation = GuildInvitation.create(user_id: user.id, invited_user_id: invited_user.id, guild_id: user.in_guild.id)
    render json: { guild_invitation: guild_invitation.id }
  end

  def destroy
    guild_invitation = GuildInvitation.find_by_id(params[:id])
    return render_error("길드 초대 거부 실패", "존재하지 않는 길드 초대입니다.", 400) if guild_invitation.nil?
    return render_error("길드 초대 거부 실패", "거부 권한이 없습니다.", 400) if @current_user.id != guild_invitation.invited_user_id
    guild_invitation.destroy
    head :no_content, status: 204
  end
end
