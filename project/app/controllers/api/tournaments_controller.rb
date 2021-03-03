class Api::TournamentsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :index, :create ]

  def index
    tournaments = {}
    if params[:for] == "tournament_index"
      tournaments = Tournament.for_tournament_index(@current_user)
    else
      tournaments = Tournament.all
    end
    render json: { tournaments: tournaments }
  end

  def create
    return render_error("UNAUTHORIZATION", "토너먼트 생성 권한이 없습니다.", 403) unless Tournament.can_be_created_by?(@current_user)

    begin
      tournament = Tournament.create_by(create_params)
      render json: { tournament: tournament }
    rescue => e
      return render_error("INVALID TOURNAMENT", e.message, 400)
    end
  end

  private

  def create_params
    params.require(:tournament).permit(:title, :rule_id, :max_user_count, :start_date, :tournament_time, :incentive_title, :incentive_gift, :target_match_score)
  end
end
