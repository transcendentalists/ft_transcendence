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
    render plain: params[:guild_id] + " guild membership update " + params[:id]
  end

  def destroy
    GuildMembership.find(params[:id])&.destroy
  end
end
