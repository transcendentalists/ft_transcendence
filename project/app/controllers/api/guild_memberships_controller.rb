class Api::GuildMembershipsController < ApplicationController
  def index
    render plain: params[:guild_id] + ' guild membership index'
  end

  def create
    if not Guild.exists?(params[:guild_id])
      return(
        render_error('길드 가입 실패', '해당 길드가 존재하지 않습니다.', '404')
      )
    end
    guild_membership =
      GuildMembership.create(
        user_id: params[:user][:id],
        guild_id: params[:guild_id],
        position: params[:position],
      )
    if not guild_membership.valid?
      return(
        render_error(
          '길드 가입 실패',
          '유효하지 않은 정보가 포함되어 있습니다.',
          '404',
        )
      )
    end
    render json: { guildMembership: guild_membership.profile }
  end

  def update
    render plain: params[:guild_id] + ' guild membership update ' + params[:id]
  end

  def destroy
    GuildMembership.find(params[:id])&.destroy
  end
end
