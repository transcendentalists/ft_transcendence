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
    if war_request.nil?
      return render_error("전쟁 요청 검색 에러", "요청하신 전쟁 요청이 존재하지 않습니다.", 404)
    end
    return render_error("권한 에러", "접근 권한이 없습니다.", 401) if !war_request.can_be_updated_by(@current_user)

    if params[:status] == "progress"
      challenger_guild_id = war_request.war_statuses.find_by_position("challenger")&.guild.id
      enemy_guild_id = war_request.war_statuses.find_by_position("enemy")&.guild.id 
      if !Guild.find_by_id(enemy_guild_id).requests.find_by_status("progress").nil?
        return render_error("전쟁 승락 에러", "이미 진행중인 전쟁이 있습니다.", 404)
      elsif !Guild.find_by_id(challenger_guild_id).requests.find_by_status("progress").nil?
        return render_error("전쟁 승락 에러", "상대 길드가 전쟁을 진행 중입니다.", 404)
      end
    end

    war_request.update(status: params[:status]) if params[:status]
    War.create(war_request_id: war_request.id, status: "progress")
    head :no_content, status: 204
  end

  private
  def check_headers_and_find_current_user
    if !request.headers['HTTP_CURRENT_USER']
      return render_error("NOT VALID HEADERS", "필요한 요청 Header가 없습니다.", 400)
    end
    @current_user = User.find_by_id(request.headers['HTTP_CURRENT_USER'])
    if @current_user.nil?
      return render_error("NOT VALID HEADERS", "요청 Header의 값이 유효하지 않습니다.", 400)
    end
  end

end
