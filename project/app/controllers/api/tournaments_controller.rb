class Api::TournamentsController < ApplicationController
  def index
    render plain: "get /api/tournaments"
  end

  def create
    render plain: "post /api/tournaments"
  end

  def enroll
    render plain: "You just enrolled at " + params[:id] + " tournaments"
  end
end
