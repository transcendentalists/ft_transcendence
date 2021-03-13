class Api::TournamentMembershipsController < ApplicationController
  before_action :check_headers_and_find_current_user

  def create
    begin
      tournament = Tournament.find(params[:tournament_id])
      tournament_membership = tournament.enroll!(@current_user)
      render json: {
        tournament_match: tournament.profile.merge({
          current_user_next_match: tournament_membership.next_match
        })
      }      
    rescue ServiceError => e
      render_error(e.type, e.message)
    rescue
      render_error :Conflict
    end
  end

end
