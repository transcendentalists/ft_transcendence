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
        user = User.find(params[:user_id])
        match = find_or_create_match!(user)
        render json: { match: match.create_response({by: user}) }
      end
    rescue ServiceError => e
      render_error(e.type, e.message)
    rescue
      render_error :Conflict
    end
  end

  private

  def find_or_create_match!(user)
    match_type, match_id, rule_id, target_score = params.values_at(:match_type, :match_id, :rule_id, :target_score)
    if ["ladder", "casual_ladder"].include?(match_type)
      find_or_create_ladder_match_for(user, { type: match_type } )
    elsif match_type == "dual"
      if match_id.nil?
        create_dual_match_for(user, rule_id, target_score)
      else
        join_dual_match_for(user, match_id)
      end
    end
  end

  def find_or_create_ladder_match_for(user, options = {type: "casual_ladder"} )
    return nil if user.playing?
    ActiveRecord::Base.transaction do
      @match = Match.where(match_type: options[:type], status: "pending").last
      @match = Match.create(match_type: options[:type], rule_id: 1) if @match.nil?
      @match.with_lock do
        user_count = Scorecard.where(match_id: @match.id).count
        if user_count >= 2
          @match = Match.create(match_type: options[:type], rule_id: 1)
        end
        side = @match.users.count == 0 ? "left" : "right"
        card = Scorecard.create(user_id: user.id, match_id: @match.id, side: side)
        user.update_status("playing")
      end
    end
    @match
  end

  def create_dual_match_for(user, rule_id, target_score)
    match =
      Match.create(
        match_type: 'dual',
        status: 'pending',
        rule_id: rule_id,
        target_score: target_score,
      )
    card = Scorecard.create(user_id: user.id, match_id: match.id, side: 'left')
    user.update_status('playing')
    match
  end

  def join_dual_match_for(user, match_id)
    match = Match.find(match_id)
    card = Scorecard.create(user_id: user.id, match_id: match_id, side: 'right')
    user.update_status('playing')
    match
  end
end
