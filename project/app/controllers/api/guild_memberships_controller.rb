class Api::GuildMembershipsController < ApplicationController
  def index
    render plain: params[:guild_id] + " guild membership index"
  end

  def create
    guild_membership = GuildMembership.create(
      user_id: params[:user][:id],
      guild_id: params[:guild_id],
      position: params[:position],
    )
    render json: { guildMembership: {
      id: guild_membership.id,
      user_id: guild_membership.user_id,
      guild_id: guild_membership.guild_id
      }
    }
  end

  def update
    unless GuildMembership.exists?(id: params[:id])
      render :json => { error: {
        'type': '관리자 임명 실패', 'msg': "이미 관리자이거나 탈퇴한 멤버입니다."
        }
      }, :status => 401
    end
    GuildMembership.find_by_id(params[:id])&.update(position: params[:position])
  end

  def destroy
    unless GuildMembership.exists?(id: params[:id])
      render :json => { error: {
        'type': '관리자 제명 실패', 'msg': "이미 제명되었거나 탈퇴한 멤버입니다."
        }
      }, :status => 401
    end
    GuildMembership.find_by_id(params[:id])&.destroy
  end
end
