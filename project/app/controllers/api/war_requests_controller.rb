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

  def update
    war_request = WarRequest.find_by_id(params[:id])
    if war_request.nil?
      render_error("전쟁 요청 검색 에러", "요청하신 전쟁요청이 존재하지 않습니다.", 404)
    end
    war_request.update(status: params[:status]) if params[:status]
    head :no_content, status: 204
  end
end
