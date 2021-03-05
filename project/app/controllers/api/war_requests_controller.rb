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
    ActiveRecord::Base.transaction do
      begin
        params = create_params
        guild = Guild.find_by_id(params[:guild_id])
        raise WarRequestError.new("권한이 없습니다.", 403) unless WarRequest.can_be_created_by?(@current_user, guild)
        war_request = WarRequest.create_by(params)
        war_status = war_request.create_war_statuses(params[:guild_id], params[:enemy_guild_id])
        raise WarRequestError.new("이미 요청한 전쟁이 있습니다.") if war_request.overlapped?
      rescue => e
        if e.class == ActionController::UnpermittedParameters
          render_error("전쟁 요청 실패", "허용되지 않은 데이터가 보내졌습니다.", 400)
        elsif e.class == ActionController::ParameterMissing
          render_error("전쟁 요청 실패", "전송되지 않은 정보가 있습니다.", 400)
        elsif e.class == ActiveRecord::RecordInvalid
          key =  e.record.errors.attribute_names.first
          error_message = e.record.errors.messages[key].first
          render_error("전쟁 요청 실패", error_message, 400)
        elsif e.class == Date::Error
          render_error("전쟁 요청 실패", "유효하지 않은 날짜 형식입니다.", 400)
        elsif e.class == WarRequestError
          render_error("전쟁 요청 실패", e.message, e.status_code)
        else
          render_error("전쟁 요청 실패", "잘못된 요청입니다.", 400)
        end
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
end
