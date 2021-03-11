class Api::MatchesController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :create ]

  def index
    if params[:user_id]
      match_history_list = Match.for_user_index(params[:user_id])
      render json: { matches: match_history_list }
    elsif params[:war_id]
      render plain: 'This is war ' + params[:war_id] + "'s matches"
    elsif params[:for] == "live"
      render json: {
        matches: Match.for_live(params[:match_type])
      }
    else
      render plain: 'get /api/matches/index'
    end
  end

  def create
    begin
      match = find_or_create_match(@current_user)
      render json: { match: { id: match.id } }
    rescue => e
      p '-------------------------------'
      p e
      p '-------------------------------'
      return render_error("매치 생성 실패", "매치 생성에 실패했습니다.", 500)
    end
  end

  private

  def find_or_create_match(user)
    if ["ladder", "casual_ladder"].include?(params[:match_type])
      match = find_or_create_ladder_match_for(user, { type: params[:match_type]} )
    else
      match = params[:match_id].nil? ? create_match_for(user, params) : join_match_for(user, params[:match_id])
    end
    match
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

  def create_war_match(user, params)
    war = War.find(params[:war_id])
    match = nil
    war.with_lock do
      raise "War match 이미 진행 중" if war.pending_or_progress_battle_exist?
      create_params = {
        match_type: params[:match_type],
        status: 'pending',
        rule_id: params[:rule_id],
        target_score: params[:target_score],
      }
      match = war.matches.create(create_params)
      card = match.scorecards.create(user_id: user.id, side: 'left')
      user.update_status('playing')
      war.set_schedule_at_no_reply_time(match)
    end
    match
  end

  def create_match_for(user, params)
    return create_war_match(user, params) if params[:match_type] == "war"

    create_params = {
      match_type: params[:match_type],
      status: 'pending',
      rule_id: params[:rule_id],
      target_score: params[:target_score],
    }
    match = Match.create(create_params)
    card = Scorecard.create(user_id: user.id, match_id: match.id, side: 'left')
    user.update_status('playing')
    match
  end

  def join_match_for(user, match_id)
    match = Match.find(match_id)
    card = Scorecard.create(user_id: user.id, match_id: match_id, side: 'right')
    user.update_status('playing')
    match
  end

end
