class Api::WarRequestsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :update ]

  def index
    if params[:for] == "guild_index"
      render json: { war_requests: WarRequest.for_guild_index(params[:guild_id]) }
    else
      render plain: params[:guild_id] + " guild's war requests index"
    end
  end

  # TODO: 만약 현재 전쟁 진행중이면 전쟁제안은 하지 못한다.
  def create
    render plain: params[:guild_id] + " guild's war requests created"
  end

  def update
    war_request = WarRequest.find_by_id(params[:id])
    return render_error("전쟁 제안 검색 에러", "요청하신 전쟁 제안이 존재하지 않습니다.", 404) if war_request.nil?
    return render_error("권한 에러", "접근 권한이 없습니다.", 401) unless war_request.can_be_updated_by(@current_user)
    if params[:status] == "accepted"
      return render_error("전쟁 수락 에러", "이미 수락되었거나 취소된 전쟁입니다.", 404) if war_request.status != "pending"
      if war_request.enemy.in_war?
        return render_error("전쟁 수락 에러", "이미 진행중인 전쟁이 있습니다.", 404)
      elsif war_request.challenger.in_war?
        return render_error("전쟁 수락 에러", "상대 길드가 전쟁을 진행 중입니다.", 404)
      end
      war_request.enemy.accept(war_request)
    else
      war_request.update(status: params[:status]) if params[:status]
    end
    head :no_content, status: 204
  end
end
