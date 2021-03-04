class Api::WarRequestsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :update, :create ]

  def index
    if params[:for] == "guild_index"
      render json: { war_requests: WarRequest.for_guild_index(params[:guild_id]) }
    else
      render plain: params[:guild_id] + " guild's war requests index"
    end
  end

  def create
    begin
      params = create_params # <== Missingparams UnpermittedParameters
    rescue ActionController::ParameterMissing => e
      return render_error("전쟁 요청 실패", "전송되지 않은 정보가 있습니다.")
    end

    if @current_user.in_guild&.id != params[:guild_id].to_i ||
      !@current_user.guild_membership.master?
      return render_error("전쟁 요청 실패", "권한이 없습니다.", 401)
    end
    return render_error("전쟁 요청 실패", "유효하지 않은 날짜 형식입니다.", 400) unless check_format_of_start_date?(params[:start_date])
    return render_error("전쟁 요청 실패", @error_message, 400) unless check_guild_condition(params)
    ActiveRecord::Base.transaction do
      begin
        war_request = WarRequest.create_by(params)
        war_request.create_war_statuses(params[:guild_id], params[:enemy_guild_id])
      rescue => e
        render_error("전쟁 요청 실패", e.class == ArgumentError ? e.message : "잘못된 요청입니다.", 400)
        raise ActiveRecord::Rollback
      end
    end
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

  private

  def create_params
    params.require(:guild_id)
    params.require(:enemy_guild_id)
    params.require(:war_duration)
    params.require(:war_request).permit(:rule_id, :bet_point, :start_date, :war_time, :max_no_reply_count, :include_ladder, :include_tournament, :target_match_score)
    params
  end

  def check_format_of_start_date?(str)
    begin
      date = Date.parse(str)
    rescue
      return false
    end
    true
  end

  def check_guild_condition(params)
    challenger_guild = @current_user.in_guild
    enemy_guild = Guild.find_by_id(params[:enemy_guild_id])
    @error_message = nil
    if enemy_guild.nil?
      @error_message = "존재하지 않는 길드입니다." 
    elsif enemy_guild.in_war? || challenger_guild.in_war?
      @error_message = "진행 중인 전쟁이 있습니다."
    elsif challenger_guild.point < params[:bet_point].to_i
      @error_message= "길드 포인트가 부족합니다." 
    end
    return false unless @error_message.nil?
    enemy_guild.requests.where(status: "pending").each do |request|
      if request.challenger.id == challenger_guild.id
        @error_message = "중복된 요청입니다."
        return false
      end
    end
    true
  end
end
