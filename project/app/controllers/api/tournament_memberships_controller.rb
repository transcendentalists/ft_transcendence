class Api::TournamentMembershipsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :create ]

  def create
    tournament = Tournament.find_by_id(params[:tournament_id])
    return render_error('존재하지 않는 토너먼트', '존재하지 않는 토너먼트입니다.', 404) if tournament.nil?

    begin
      tournament_membership = tournament.enroll(@current_user)
    rescue => e
      msg = (e.message == "StandardError") ? '토너먼트 등록에 실패했습니다.' : e.message
      return render_error('토너먼트 등록 실패', msg, 500)
    end

    render json: {
      tournament_match: tournament.profile.merge({
        current_user_next_match: tournament_membership.next_match
      })
    }
  end

end