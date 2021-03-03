class Api::WarRequestsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :update, :create ]

  def index
    if params[:for] == "guild_index"
      render json: { war_requests: WarRequest.for_guild_index(params[:guild_id]) }
    else
      render plain: params[:guild_id] + " guild's war requests index"
    end
  end

  # TODO: 트랜잭션으로 war_status까지 같이 만들어주기
  def create
    if @current_user.in_guild&.id != params[:guild_id].to_i ||
      !@current_user.guild_membership.master?
      return render_error("전쟁 요청 실패", "권한이 없습니다.", 401)
    end
    challenger_guild = @current_user.in_guild
    enemy_guild = Guild.find_by_id(params[:enemy_guild_id])
    return render_error("전쟁 요청 실패", "존재하지 않는 길드입니다.", 400) if enemy_guild.nil?
    return render_error("전쟁 요청 실패", "진행 중인 전쟁이 있습니다.", 400) if enemy_guild.in_war? || challenger_guild.in_war?
    enemy_guild.requests.where(status: "pending").each do |request|
      return render_error("전쟁 요청 실패", "중복된 요청입니다.", 400) if request.challenger.id == challenger_guild.id
    end
    war_request = WarRequest.create(
      rule_id: params[:rule_id],
      bet_point: params[:bet_point],
      start_date: Date.parse(params[:war_start_date]),
      end_date: Date.parse(params[:war_start_date]) + params[:war_duration].to_i.days,
      war_time: Time.new(1 ,1 ,1 , params[:war_time].to_i),
      max_no_reply_count: params[:max_no_reply_count],
      include_ladder: params[:include_ladder],
      include_tournament: params[:include_tournament],
      target_match_score: params[:target_match_score],
    )
    return render_error("전쟁 요청 실패", "잘못된 요청입니다.", 400) if war_request.nil?
    unless war_request.valid?
      error_message = war_request.errors[war_request.errors.attribute_names.first].first
      return render_error("전쟁 요청 실패", error_message, 400) 
    end
    WarStatus.create(guild_id: @current_user.in_guild.id, war_request_id: war_request.id, position: "challenger")
    WarStatus.create(guild_id: params[:enemy_guild_id], war_request_id: war_request.id, position: "enemy")
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
