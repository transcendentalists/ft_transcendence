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
    unless WarRequest.exists?(id: params[:id])
      render :json => { error: {
        'type': 'War Request', 'msg': "이미 거절되었거나 존재하지 않는 전쟁요청입니다."
        }
      }, :status => 401
    end
    WarRequest.find_by_id(params[:id])&.destroy
  end
end
