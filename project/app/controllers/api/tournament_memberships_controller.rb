class Api::TournamentMembershipsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :create ]

  def create
    return render_error('존재하지 않는 토너먼트', '존재하지 않는 토너먼트입니다.', 404) unless Tournament.exists?(params[:tournament_id])
    tournament_membership =
      TournamentMembership.create(
        user_id: @current_user.id,
        tournament_id: params[:tournament_id],
      )
    return render_error('토너먼트 등록 실패', '토너먼트 등록에 실패했습니다.', 500) unless tournament_membership.persisted?
    render json: { tournament_match: tournament_membership.next_match }
  end

end
