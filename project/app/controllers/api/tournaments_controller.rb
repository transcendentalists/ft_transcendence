class Api::TournamentsController < ApplicationController
  before_action :check_headers_and_find_current_user

  def index
    begin
      if params[:for] == "tournament_index"
        tournaments = Tournament.for_tournament_index(@current_user)
        render json: { tournaments: tournaments }
      else
        render_error :BadRequest
      end
    rescue => e
      perror e
      render_error :Conflict
    end
  end

  def create
    begin
      raise ServiceError.new(:Forbidden) unless Tournament.can_be_created_by?(@current_user)
      tournament = Tournament.create_by!(create_params)
      render json: { tournament: tournament }
    rescue Date::Error => e
      perror e
      render_error(:BadRequest, "유효하지 않은 날짜입니다.")
    rescue ActiveRecord::RecordInvalid => e
      perror e
      key =  e.record.errors.attribute_names.first
      error_message = e.record.errors.messages[key].first
      render_error(:BadRequest, error_message)
    rescue ServiceError => e
      perror e
      render_error(e.type)
    rescue => e
      perror e
      render_error :Conflict
    end
  end

  private

  def create_params
    params.require(:tournament).permit(:title, :rule_id, :max_user_count, :start_date, :tournament_time, :incentive_title, :incentive_gift, :target_match_score)
  end
end
