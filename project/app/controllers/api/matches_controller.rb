class Api::MatchesController < ApplicationController
  before_action :check_headers_and_find_current_user

  def index
    begin
      if params[:user_id]
        match_history_list = Match.for_user_index(params[:user_id])
        render json: { matches: match_history_list }
      elsif params[:for] == "live"
        render json: { matches: Match.for_live(params[:match_type]) }
      else
        render_error :BadRequest
      end
    rescue
      render_error :Conflict
    end
  end

  def create
    begin
      raise ServiceError.new(:BadRequest) unless params[:user_id]
      match = find_or_create_match!
      render json: { match: { id: match.id } }
    rescue ServiceError => e
      render_error(e.type, e.message)
    rescue
      render_error :Conflict
    end
  end

  private

  def find_or_create_match!
    match_type, match_id = params.values_at(:match_type, :match_id)
    if ["ladder", "casual_ladder"].include?(match_type)
      Match.find_or_create_ladder_match_by!({ by: @current_user, type: match_type } )
    else
      if match_id.nil?
        create_match!
      else
        Match.find_and_join_match_by!({by: @current_user, match_id: match_id})
      end
    end
  end

  # 현재 create_match_type은 war가 아닐 경우 dual
  def create_match!
    return create_war_match! if params[:match_type] == "war"
    match = nil
    ActiveRecord::Base.transaction do
      match = Match.create(create_params)
      match.scorecards.create(user_id: @current_user.id, side: 'left')
      @current_user.update_status('playing')
    end
    match
  end

  def create_war_match!
    war = War.find(params[:war_id])
    match = nil
    war.with_lock do
      raise ServiceError.new if war.pending_or_progress_battle_exist?
      ActiveRecord::Base.transaction do
        match = war.matches.create!(create_params)
        match.scorecards.create!(user_id: @current_user.id, side: 'left')
        @current_user.update_status('playing')
        war.set_schedule_at_no_reply_time(match)
      end
    end
    match
  end

  def create_params
    params.permit(:match_type, :rule_id, :target_score)
  end
end
