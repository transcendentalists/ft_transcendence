class Api::GuildMembershipsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :create, :update, :destroy ]

  def index
    render plain: params[:guild_id] + ' guild membership index'
  end

  def create
    return render_error("권한 에러", "접근 권한이 없습니다.", 401) if @current_user.id != params[:user][:id]
    return render_error('길드 가입 실패', '해당 길드 또는 유저가 존재하지 않습니다.', 404) unless Guild.exists?(params[:guild_id])
    guild_membership =
      GuildMembership.create(
        user_id: params[:user][:id],
        guild_id: params[:guild_id],
        position: params[:position],
      )
    return(render_error('길드 가입 실패', '유효하지 않은 정보가 포함되어 있습니다.', 404) unless guild_membership.valid?
    render json: { guildMembership: guild_membership.profile }
  end

  def update
    render plain: params[:guild_id] + ' guild membership update ' + params[:id]
  end

  def destroy
    membership = GuildMembership.find_by_id(params[:id])
    return render_error("길드 탈퇴 실패", "해당 유저의 길드 정보가 존재하지 않습니다.", 401) if membership.nil?
    return render_error("권한 에러", "접근 권한이 없습니다.", 401) unless membership.can_be_destroyed_by?(@current_user)
    membership.destroy
    head :no_content, status: 204
  end
end
