class Api::TournamentsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :index ]

  def index
    tournaments = {}
    if params[:for] == "tournament_index"
      tournaments = Tournament.for_tournament_index(@current_user)
    else
      tournaments = Tournament.all
    end
    render :json => { tournaments: tournaments }
  end

  def create
    render plain: "post /api/tournaments"
  end

  def enroll
    render plain: "You just enrolled at " + params[:id] + " tournaments"
  end
end
