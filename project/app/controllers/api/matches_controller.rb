class Api::MatchesController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :create ]

  #TODO: 현재 버전에서 else case로 들어오는 요청 없음
  def index
    if params[:user_id]
      match_history_list = Match.for_user_index(params[:user_id])
      render json: { matches: match_history_list }
    elsif params[:for] == "live"
      render json: { matches: Match.for_live(params[:match_type]) }
    else
      render json: { matches: Match.all }
    end
  end

  def create
    begin
      match = find_or_create_match
      render json: { match: { id: match.id } }
    rescue
      #TODO: Conflict
      render_error("매치 생성 실패", "매치 생성에 실패했습니다.", 400)
    end
  end

  private

  def find_or_create_match
    if ["ladder", "casual_ladder"].include?(params[:match_type])
      find_or_create_ladder_match_for({ type: params[:match_type] })
    else
      params[:match_id].nil? ? create_match : find_and_join_match_by(params[:match_id])
    end
  end

  def find_or_create_ladder_match_for(options = {type: "casual_ladder"} )
    return nil if @current_user.playing?
    ActiveRecord::Base.transaction do
      @match = Match.where(match_type: options[:type], status: "pending").last
      @match = Match.create(match_type: options[:type], rule_id: 1) if @match.nil?
      @match.with_lock do
        user_count = Scorecard.where(match_id: @match.id).count
        if user_count >= 2
          @match = Match.create(match_type: options[:type], rule_id: 1)
        end
        side = @match.users.count == 0 ? "left" : "right"
        @match.scorecards.create(user_id: @current_user.id, side: side)
        @current_user.update_status("playing")
      end
    end
    @match
  end

  # 현재 create_match_type은 war가 아닐 경우 dual
  def create_match
    return create_war_match if params[:match_type] == "war"
    ActiveRecord::Base.transaction do
      match = Match.create(create_params)
      match.scorecards.create(user_id: @current_user.id, side: 'left')
      @current_user.update_status('playing')
    end
    match
  end

  def create_war_match
    war = War.find(params[:war_id])
    match = nil
    war.with_lock do
      #TODO: BadRequest ServiceError
      raise "War match 이미 진행 중" if war.pending_or_progress_battle_exist?

      match = war.matches.create(create_params)
      match.scorecards.create(user_id: @current_user.id, side: 'left')
      @current_user.update_status('playing')
      war.set_schedule_at_no_reply_time(match)
    end
    match
  end

  def find_and_join_match_by(match_id)
    match = Match.find(match_id)
    match.with_lock do
      #TODO: BadRequest
      raise "Game already started" if match.users.count == 2
      if match.match_type == "war"
        enemy = match.users.first
        #TODO: BadRequest
        raise "Users are same guild members" if @current_user.in_guild.id == enemy.in_guild.id
      end
      match.scorecards.create!(user_id: @current_user.id, side: 'right')
      @current_user.update_status('playing')
    end
    match
  end

  def create_params
    params.permit(:match_type, :rule_id, :target_score)
  end
end
