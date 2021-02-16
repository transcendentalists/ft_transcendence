class Api::WarRequestsController < ApplicationController
  def index
    if params[:for] == "guild_index"
      render json: { war_requests: WarRequest.for_guild_index(params[:guild_id]) }
    else
      render plain: params[:guild_id] + " guild's war requests index"
    end
  end

  def create
    render plain: params[:guild_id] + " guild's war requests created"
  end

  def destroy
    render plain: params[:guild_id] + " guild destory " + params[:id] + " war request"
  end
end
