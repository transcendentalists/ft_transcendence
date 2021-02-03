class Api::GuildMembershipsController < ApplicationController
  def index
    render plain: params[:guild_id] + " guild membership index"
  end

  def create
    render plain: params[:guild_id] + " guild membership create"
  end

  def update
    render plain: params[:guild_id] + " guild membership update " + params[:id]
  end

  def destroy
    render plain: params[:guild_id] + " guild membership destroy " + params[:id]
  end
end
